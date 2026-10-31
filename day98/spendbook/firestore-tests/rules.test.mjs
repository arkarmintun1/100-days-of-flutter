// Day 92: Spendbook's Firestore rules, tested on the Firestore emulator.
//
//   cd firestore-tests && npm install
//   firebase emulators:exec --only firestore --project demo-spendbook \
//     "npm --prefix firestore-tests test"
import { readFileSync } from 'node:fs';
import { after, before, beforeEach, describe, test } from 'node:test';

import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} from '@firebase/rules-unit-testing';
import {
  Timestamp,
  deleteDoc,
  doc,
  getDoc,
  serverTimestamp,
  setDoc,
  updateDoc,
} from 'firebase/firestore';

let env;

before(async () => {
  env = await initializeTestEnvironment({
    projectId: 'demo-spendbook',
    firestore: {
      rules: readFileSync(new URL('../firestore.rules', import.meta.url), 'utf8'),
      host: '127.0.0.1',
      port: 8080,
    },
  });
});
beforeEach(() => env.clearFirestore());
after(() => env.cleanup());

/** What FirestoreExpenseRemote writes (lib/data/models/expense_firestore.dart). */
const expense = (changes = {}) => ({
  title: 'Lunch',
  amountCents: 1250,
  category: 'food',
  date: Timestamp.fromDate(new Date('2026-10-28T12:00:00Z')),
  note: null,
  original: null,
  updatedAt: 1793180000000,
  deleted: false,
  syncedAt: serverTimestamp(),
  ...changes,
});

const mya = () => env.authenticatedContext('mya').firestore();
const lunch = (db, owner = 'mya') => doc(db, `users/${owner}/expenses/lunch`);

describe('who', () => {
  test('a user writes and reads their own expenses', async () => {
    await assertSucceeds(setDoc(lunch(mya()), expense()));
    await assertSucceeds(getDoc(lunch(mya())));
  });

  test("another user can't read them or write there", async () => {
    await assertSucceeds(setDoc(lunch(mya()), expense()));
    const ko = env.authenticatedContext('ko').firestore();
    await assertFails(getDoc(lunch(ko, 'mya')));
    await assertFails(setDoc(lunch(ko, 'mya'), expense()));
  });

  test('nobody signed in: no access', async () => {
    const nobody = env.unauthenticatedContext().firestore();
    await assertFails(getDoc(lunch(nobody)));
    await assertFails(setDoc(lunch(nobody), expense()));
  });

  test('nothing outside users/{uid}/expenses', async () => {
    await assertFails(setDoc(doc(mya(), 'users/mya'), { name: 'Mya' }));
    await assertFails(setDoc(doc(mya(), 'expenses/lunch'), expense()));
  });
});

describe('what', () => {
  test('the app\'s own expenses are valid, in another currency too', async () => {
    await assertSucceeds(setDoc(lunch(mya()), expense({ note: 'Noodles' })));
    const paid = { currency: 'SGD', minorUnits: 1600, decimalDigits: 2 };
    await assertSucceeds(
      setDoc(doc(mya(), 'users/mya/expenses/sgd'), expense({ original: paid })),
    );
    await assertSucceeds(
      setDoc(doc(mya(), 'users/mya/expenses/emoji'), expense({ title: '👍'.repeat(60) })),
    );
  });

  for (const [why, changes] of [
    ['no title', { title: '' }],
    ['an amount of 0', { amountCents: 0 }],
    ['an amount that isn\'t an int', { amountCents: 12.5 }],
    ['an unknown category', { category: 'travel' }],
    ['a date that isn\'t a timestamp', { date: '2026-10-28' }],
    ['a field the app doesn\'t know', { tip: 100 }],
    ['the phone\'s time as syncedAt', { syncedAt: Timestamp.now() }],
    ['a bad currency', { original: { currency: 'S', minorUnits: 1, decimalDigits: 2 } }],
  ]) {
    test(`not with ${why}`, async () => {
      await assertFails(setDoc(lunch(mya()), expense(changes)));
    });
  }

  test('not without a required field', async () => {
    const { amountCents, ...rest } = expense();
    await assertFails(setDoc(lunch(mya()), rest));
  });
});

describe('deleting', () => {
  test('an expense becomes a tombstone', async () => {
    await assertSucceeds(setDoc(lunch(mya()), expense()));
    await assertSucceeds(setDoc(lunch(mya()), expense({ deleted: true })));
  });

  test('a tombstone stays one (Day 91: deletions are final)', async () => {
    await assertSucceeds(setDoc(lunch(mya()), expense({ deleted: true })));
    await assertFails(setDoc(lunch(mya()), expense({ deleted: false })));
    await assertFails(updateDoc(lunch(mya()), { deleted: false, syncedAt: serverTimestamp() }));
  });

  test('really deleting a document is not allowed', async () => {
    await assertSucceeds(setDoc(lunch(mya()), expense()));
    await assertFails(deleteDoc(lunch(mya())));
  });
});

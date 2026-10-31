import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// fpdart has its own State class: take only what's needed.
import 'package:fpdart/fpdart.dart' show Either, Left;

import '../../domain/entities/app_user.dart';
import '../../domain/failures.dart';
import '../providers/auth.dart';
import '../providers/sync.dart';

/// Day 90: who you are in Spendbook. A guest, an account, or nobody.
class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ready = ref.watch(firebaseReadyProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: !ready
          ? const _Message(
              'Signing in needs your own Firebase project '
              '(flutterfire configure, Day 70).',
            )
          : switch (ref.watch(currentUserProvider)) {
              AsyncData(value: null) => const _SignedOut(),
              AsyncData(value: final user?) when user.isGuest => const _Guest(),
              AsyncData(value: final user?) => _SignedIn(user),
              AsyncError() => const _Message(
                "Couldn't check who is signed in.",
              ),
              _ => const Center(child: CircularProgressIndicator()),
            },
    );
  }
}

class _Message extends StatelessWidget {
  const _Message(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Text(text, textAlign: TextAlign.center),
    ),
  );
}

class _Guest extends StatelessWidget {
  const _Guest();

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      const ListTile(
        leading: Icon(Icons.person_outline),
        title: Text('You are using Spendbook as a guest'),
        subtitle: Text(
          'Your expenses are backed up to this guest account. Add an email '
          'and a password to get them back on another phone.',
        ),
      ),
      const _SyncTile(),
      const SizedBox(height: 8),
      const _AccountForm(),
    ],
  );
}

class _SignedOut extends ConsumerWidget {
  const _SignedOut();

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      const ListTile(
        leading: Icon(Icons.person_off_outlined),
        title: Text('You are not signed in'),
      ),
      FilledButton.tonal(
        onPressed: () async {
          final result = await ref
              .read(authRepositoryProvider)!
              .continueAsGuest();
          if (context.mounted) _showFailure(context, result);
        },
        child: const Text('Continue as a guest'),
      ),
      const SizedBox(height: 16),
      const _AccountForm(signInFirst: true),
    ],
  );
}

class _SignedIn extends ConsumerWidget {
  const _SignedIn(this.user);

  final AppUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      ListTile(
        leading: const Icon(Icons.verified_user_outlined),
        title: const Text('Signed in'),
        subtitle: Text(user.email!),
      ),
      const _SyncTile(),
      const SizedBox(height: 8),
      OutlinedButton(
        // Day 91: uploads what's left, then this phone forgets the expenses.
        onPressed: () => _signOut(context, ref),
        child: const Text('Sign out'),
      ),
    ],
  );
}

Future<void> _signOut(BuildContext context, WidgetRef ref) async {
  final signOut = ref.read(signOutProvider)!;
  final userId = ref.read(currentUserIdProvider)!;
  final result = await signOut(userId);
  if (!context.mounted) return;
  if (result case Left(value: UnsavedChangesFailure(:final message))) {
    // Not uploaded: the user decides whether to lose them.
    final anyway = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign out anyway?'),
        content: Text('$message. If you sign out now, they are lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Stay signed in'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign out anyway'),
          ),
        ],
      ),
    );
    if (anyway != true) return;
    final forced = await signOut(userId, force: true);
    if (context.mounted) _showFailure(context, forced);
    return;
  }
  _showFailure(context, result);
}

/// Day 91: how syncing is going, and a button to sync now.
class _SyncTile extends ConsumerWidget {
  const _SyncTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sync = ref.watch(syncProvider);
    if (!sync.active) return const SizedBox.shrink();
    final time = switch (sync.lastSynced) {
      final at? => TimeOfDay.fromDateTime(at).format(context),
      null => null,
    };
    return ListTile(
      leading: Icon(
        sync.error == null ? Icons.cloud_done_outlined : Icons.cloud_off,
      ),
      title: Text(switch (sync) {
        SyncState(syncing: true) => 'Syncing…',
        SyncState(:final error?) => error,
        SyncState(pending: > 0) => '${sync.pending} changes to upload',
        _ when time != null => 'Synced at $time',
        _ => 'Not synced yet',
      }),
      trailing: IconButton(
        tooltip: 'Sync now',
        icon: const Icon(Icons.sync),
        onPressed: sync.syncing
            ? null
            : () => ref.read(syncProvider.notifier).syncNow(),
      ),
    );
  }
}

/// Email and password: "Create account" for a guest, or "Sign in".
class _AccountForm extends ConsumerStatefulWidget {
  const _AccountForm({this.signInFirst = false});

  final bool signInFirst;

  @override
  ConsumerState<_AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends ConsumerState<_AccountForm> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  late var _signIn = widget.signInFirst;
  var _busy = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final Either<Failure, AppUser> result;
    if (_signIn) {
      result = await ref.read(signInProvider)!(
        email: _email.text,
        password: _password.text,
      );
    } else {
      result = await ref.read(createAccountProvider)!(
        email: _email.text,
        password: _password.text,
      );
    }
    if (!mounted) return;
    setState(() {
      _busy = false;
      _error = switch (result) {
        Left(value: final failure) => failure.message,
        _ => null,
      };
    });
    // Success: currentUserProvider changes and the screen shows the account.
  }

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _email,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            autocorrect: false,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _password,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            autofillHints: [
              _signIn ? AutofillHints.password : AutofillHints.newPassword,
            ],
          ),
          if (_error case final error?)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                error,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _busy ? null : _submit,
            child: Text(_signIn ? 'Sign in' : 'Create account'),
          ),
          TextButton(
            onPressed: _busy
                ? null
                : () => setState(() {
                    _signIn = !_signIn;
                    _error = null;
                  }),
            child: Text(
              _signIn
                  ? 'New here? Create an account'
                  : 'Already have an account? Sign in',
            ),
          ),
        ],
      ),
    );
  }
}

void _showFailure(BuildContext context, Either<Failure, Object> result) {
  if (result case Left(value: final failure)) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(failure.message)));
  }
}

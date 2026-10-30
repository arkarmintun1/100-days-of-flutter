import assert from "node:assert/strict";
import {test} from "node:test";
import {genkit} from "genkit";
import {defineEmbedTexts, normalize} from "./embed";

// A fake embedder: no network, no API key. It records the options
// and returns [3, 4] for every text.
function setUp() {
  const ai = genkit({});
  const calls: unknown[] = [];
  const fake = ai.defineEmbedder(
    {name: "fake", info: {dimensions: 2}},
    async (input, options) => {
      calls.push(options);
      return {embeddings: input.map(() => ({embedding: [3, 4]}))};
    },
  );
  return {flow: defineEmbedTexts(ai, fake), calls};
}

test("returns one normalized vector per text", async () => {
  const {flow, calls} = setUp();

  const vectors = await flow({texts: ["Hotel", "Flight"], kind: "document"});

  assert.deepEqual(vectors, [[0.6, 0.8], [0.6, 0.8]]);
  assert.deepEqual(calls[0], {
    taskType: "RETRIEVAL_DOCUMENT",
    outputDimensionality: 768,
  });
});

test("a query uses the query task type", async () => {
  const {flow, calls} = setUp();

  await flow({texts: ["where do I sleep?"], kind: "query"});

  assert.equal((calls[0] as {taskType: string}).taskType, "RETRIEVAL_QUERY");
});

test("input that doesn't fit the schema is rejected", async () => {
  const {flow} = setUp();

  await assert.rejects(flow({texts: [], kind: "query"}));
  await assert.rejects(flow({texts: [""], kind: "query"}));
  await assert.rejects(
    flow({texts: ["a"], kind: "everything"} as never),
  );
});

test("normalize scales a vector to length 1", () => {
  assert.deepEqual(normalize([3, 4]), [0.6, 0.8]);
  assert.deepEqual(normalize([0, 0]), [0, 0]);
});

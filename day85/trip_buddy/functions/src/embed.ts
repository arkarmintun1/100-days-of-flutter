import {Genkit, z} from "genkit";
import type {EmbedderArgument} from "genkit/embedder";

/** What the app sends: texts to turn into vectors (Day 75). */
export const EmbedInput = z.object({
  texts: z.array(z.string().min(1).max(4000)).min(1).max(50),
  // A document chunk and a search query are embedded differently.
  kind: z.enum(["document", "query"]),
});

/** Number of values in each vector. */
export const dimensions = 768;

export function defineEmbedTexts(ai: Genkit, embedder: EmbedderArgument) {
  return ai.defineFlow(
    {
      name: "embedTexts",
      inputSchema: EmbedInput,
      outputSchema: z.array(z.array(z.number())),
    },
    async ({texts, kind}) => {
      const results = await ai.embedMany({
        embedder,
        content: texts,
        options: {
          taskType: kind === "document" ? "RETRIEVAL_DOCUMENT" : "RETRIEVAL_QUERY",
          outputDimensionality: dimensions,
        },
      });
      // Below 3072 values, gemini-embedding-001 vectors aren't
      // normalized: scale each one to length 1.
      return results.map(({embedding}) => normalize(embedding));
    },
  );
}

export function normalize(vector: number[]): number[] {
  const length = Math.hypot(...vector);
  return length === 0 ? vector : vector.map((value) => value / length);
}

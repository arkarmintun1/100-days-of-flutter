import {googleAI} from "@genkit-ai/google-genai";
import {genkit} from "genkit";
import {setGlobalOptions} from "firebase-functions";
import {onCallGenkit} from "firebase-functions/https";
import {defineSecret} from "firebase-functions/params";
import {defineEmbedTexts} from "./embed";

// Set once with: firebase functions:secrets:set GEMINI_API_KEY
// The key stays on the server: the app never sees it.
const geminiApiKey = defineSecret("GEMINI_API_KEY");

// At most 10 instances at once: a cap on cost if traffic spikes.
setGlobalOptions({maxInstances: 10});

const ai = genkit({plugins: [googleAI()]});

const embedTextsFlow = defineEmbedTexts(
  ai,
  googleAI.embedder("gemini-embedding-001"),
);

// A callable function: the app calls it with
// FirebaseFunctions.instance.httpsCallable('embedTexts').
export const embedTexts = onCallGenkit(
  {
    secrets: [geminiApiKey],
    // Only requests with a valid App Check token from YOUR app.
    enforceAppCheck: true,
  },
  embedTextsFlow,
);

Sample data shaped like Pexels API responses (fields per https://www.pexels.com/api/documentation/).
IDs, names and URLs are made up for tests; they are not real Pexels photos.

`curated_page2.json` reuses the page-1 image files: its `src` URLs point at
`/photos/1001..1012/` so the fake cache manager can serve a local image.

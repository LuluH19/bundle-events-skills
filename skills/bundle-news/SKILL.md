---
name: bundle-news
description: Trigger this if the user asks for news, actualités or new articles for Bundle Events. Writes two fact-checked, SEO-ready news articles about current events and travel in France as JSON files in src/content/news, then opens a PR.
---

# Bundle news

Each run produces **two** new articles for /actualites, based on what is happening now.
Read docs/features/news-and-events.md, src/types/news.ts, the limits at the top of
src/utils/news.ts, and every file in src/content/news first: do not repeat a topic that
already has an article, and keep their tone. Work on a branch from `dev`.

## 1. Pick two topics

Search the web for the last two weeks (use the extended mode for fresh results). A good
topic matters to someone travelling to a concert, a match, a festival or a show in France:
a festival or tour announcing dates, a big match or event coming up, ticket sales opening,
train or plane sales, a strike, school holidays, a new line or timetable. Prefer one
**event** topic and one **getting there** topic. Skip celebrity gossip, politics and
anything that is not useful for planning a trip.

## 2. Check every fact

- Every date, place, price, line-up or figure needs either an official source (organiser,
  SNCF, ministry, club, venue) or two independent outlets that agree. If sources disagree,
  say so or leave the fact out. Never fill a gap with a guess.
- A fact found in a single outlet is written with attribution: « d'après Sortiraparis… ».
- Anything that can change (strike, sale status, sold-out passes) is dated: « à la date de
  publication », and the lead names the day.
- Write your own sentences. Summarise, do not copy or translate a paragraph, and quote at
  most a few words. Do not reuse images: the share image is generated from the title.
- Only describe Bundle Events features that exist on `dev` (see the app's llms.txt
  builder in src/utils/seo.ts). No promises of booking, prices or routes we do not offer.

## 3. Write for search engines and readers

French, tutoiement, short sentences, the traveller's words (see docs/design/design-system.md).

- `slug`: lowercase words and hyphens, the main keywords and the year, e.g.
  `festivals-2027-dates-hellfest-vieilles-charrues`. It is also the file name.
- `title`: the main keyword first, aim for 60 characters (70 is the hard limit), no clickbait.
- `description`: 140–160 characters (110–160 enforced), with the keyword and what the
  reader gets. It is the Google snippet.
- `lead`: two or three sentences that already answer the question.
- `blocks`: 3 to 5 `h2` sections, some phrased as the question people type
  (« Quelles sont les dates… ? »), short `p` paragraphs, at least one `ul` of practical
  tips. End with an `h2` « Préparer ton voyage avec Bundle Events » and one paragraph that
  ties the topic to the trip (trajet, hôtel près de la salle, retour, partage).
- `tags`: 4 to 6 search terms. `author`: « Équipe Bundle Events ».
- `sources`: 2 to 4, https, title as published, the outlet as `publisher`, official first.
- `publishedAt`: today in Europe/Paris, `AAAA-MM-JJ`.

## 4. Check, then open the PR

Run `npx vitest run src/__tests__/news.test.ts`: it loads every real file and fails on a
bad slug, length, date, missing `h2` or fewer than two sources. Then `npx tsc --noEmit` and
`npx eslint src`. Open `/actualites` and both articles on `npm run dev`, at 375 px and
1280 px. Open a PR into `dev` titled `feat: add news on <topics>` (no scope), listing each
fact with its source so the reviewer can check it. Never merge it yourself.

## Later edits

If a fact changes after publication, edit the article, fix the text and set `updatedAt`
instead of writing a new one. Do not delete old articles: their URLs keep ranking.

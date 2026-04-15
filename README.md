# Click-AI / AI Panel

Single-file PWA that asks Claude, Gemini and GPT-4o the same question in parallel and synthesises the result. iOS Safari friendly, deployable on GitHub Pages.

## Features
- 🎯 3 AIs in parallel via `Promise.all` (Claude Sonnet 4, Gemini 2.0 Flash, GPT-4o-mini) + Claude synthesis
- 🔍 **Native live web search** when 🔍 toggle is ON — same quality as the source apps:
  - Claude: `web_search_20250305` tool
  - Gemini: `google_search` grounding
  - GPT-4o: `gpt-4o-mini-search-preview`
- 📷 Image upload (multi) · 🎤 voice dictation (SpeechRecognition)
- 🗂 Coloured projects (8 colours), conversations, rename/clear
- ☁️ **Supabase sync**: magic-link sign-in, your projects/conversations follow you across devices
- 🔗 **Share**: publish any conversation as a read-only public link
- 🔑 API keys (Anthropic / Gemini / OpenAI) stored locally in the browser
- 📱 PWA manifest · iOS standalone mode

## Setup (one-time)
1. Create a free Supabase project.
2. Run `supabase_schema.sql` in the SQL editor.
3. In Authentication → URL Configuration, add your site URL as an allowed redirect.
4. Open the app → ⚙ Settings → paste API keys + Supabase URL + anon key → enter email → "Envoyer le magic link".

## Stack
Pure HTML/CSS/JS, no build step. Supabase JS loaded from `esm.sh`.

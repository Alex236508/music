###### 10/10/26 - fixed!
###### 8/29/26 - it's broken again! fix coming soon
###### 8/17/26 - i fixed everything!

# x8rr/music
a simple music backend in fastify, ported from cherri-v3

## sources
- tidal: search, albums, artists, artwork. works out of the box
- youtube music: the audio. **you have to set your own base** (see below)

## docs
you need [bun](https://bun.sh) and [yt-dlp](https://github.com/yt-dlp/yt-dlp) installed.

1. install and make your env file
   ```sh
   bun install
   cp .env.example .env
   ```
2. set your youtube music base in `.env`. nothing plays without it
   ```sh
   YTM_BASE=https://music.youtube.com
   ```
3. (optional) set your own r2 bucket so audio and artwork are kept for good. without it they are only cached on disk in `data/`
   ```sh
   R2_BASE=https://<account id>.r2.cloudflarestorage.com
   R2_ACCESS_KEY_ID=
   R2_SECRET_ACCESS_KEY=
   R2_BUCKET=
   ```
4. run it
   ```sh
   bun start
   ```
   then open http://localhost:2010

if it can't find yt-dlp, set `YT_DLP_PATH` to where it lives (`which yt-dlp`). if youtube blocks your server, set `YTM_INVIDIOUS_INSTANCE` to an invidious host. the rest of `.env.example` is optional.

### YouTube cookies on Render

YouTube may refuse downloads from a server with a bot check. Export a fresh
Netscape-format cookie file for a YouTube account you control, add it to Render
as a **Secret File** (for example, `/etc/secrets/cookies.txt`), and set
`YTM_COOKIES_FILE` to that exact path. Do not commit the file or add it as a
normal environment variable. The container copies the mounted secret to a
private temporary path before starting; if the configured file is missing or
unreadable, startup fails with an explicit error.

Cookie credentials expire and YouTube can still reject them. If Render reports
`Sign in to confirm you’re not a bot`, replace the Secret File with a newly
exported cookie file and redeploy. A 502 in that case means yt-dlp did not
obtain audio; the browser's unsupported-audio error is a consequence of the
failed stream, not an audio codec issue.

## routes
- `GET /api/music/search?q=&limit=&source=`
- `GET /api/music/stream?id=&source=&title=&artist=&duration=` (ranged audio)
- `GET /api/music/track`, `GET /api/music/manifest` (same lookup, json)
- `GET /api/music/browse`
- `GET /api/music/album/:id`, `/album/:id/similar`
- `GET /api/music/artist/:id`, `/artist/:id/similar`
- `GET /api/music/lookup/album?artist=&title=`, `/lookup/artist?name=`
- `GET /api/music/art?u=` (cached artwork proxy)
- `GET /api/music/ytm/audio/:id`
- `GET /api/music/source`, `POST /api/music/ping`

## dev
```sh
bun dev          # watch mode
bun test
bun run typecheck
```

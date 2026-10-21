FROM oven/bun:1

WORKDIR /app

# Install Python, pip, and ffmpeg for yt-dlp and audio processing
RUN apt-get update \
    && apt-get install -y --no-install-recommends python3 python3-pip ffmpeg \
    && pip3 install --break-system-packages --no-cache-dir -U yt-dlp \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY package.json bun.lock* ./
RUN bun install --frozen-lockfile || bun install

COPY . .

ENV NODE_ENV=production
ENV YTM_BASE=https://music.youtube.com

EXPOSE 2010

CMD ["bun", "start"]

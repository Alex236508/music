FROM oven/bun:1

WORKDIR /app

# Install Python, pip, FFmpeg, and tools needed for Deno installation
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       python3 python3-pip ffmpeg curl unzip ca-certificates \
    && pip3 install --break-system-packages --no-cache-dir -U "yt-dlp[default]" \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Deno, a supported JavaScript runtime for yt-dlp
RUN curl -fsSL https://deno.land/install.sh | sh

ENV PATH="/root/.deno/bin:${PATH}"

# Verify the actual installed tools during the image build
RUN yt-dlp --version \
    && python3 -m pip show yt-dlp yt-dlp-ejs \
    && python3 --version \
    && bun --version \
    && deno --version

COPY package.json bun.lock* ./
RUN bun install --frozen-lockfile || bun install

COPY . .

ENV NODE_ENV=production
ENV YTM_BASE=https://music.youtube.com

EXPOSE 2010

CMD ["/bin/sh", "-c", "cp \"$YTM_COOKIES_FILE\" /tmp/ytm-cookies.txt && chmod 600 /tmp/ytm-cookies.txt && export YTM_COOKIES_FILE=/tmp/ytm-cookies.txt && exec bun start"]

FROM oven/bun:1

WORKDIR /app

COPY package.json bun.lock* ./
RUN bun install --frozen-lockfile || bun install

COPY . .

ENV NODE_ENV=production
ENV PORT=2010
ENV MUSIC_PORT=2010

EXPOSE 2010

CMD ["bun", "start"]

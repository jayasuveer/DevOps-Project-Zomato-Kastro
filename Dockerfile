# ---------- Build stage ----------
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci
RUN npm audit fix || true

COPY . .

RUN npm run build


# ---------- Runtime stage ----------
FROM node:20-alpine

WORKDIR /app

# Only copy built files (not full source)
COPY --from=builder /app/build ./build
COPY --from=builder /app/package*.json ./

RUN npm ci --omit=dev

EXPOSE 3000

CMD ["npx", "serve", "-s", "build"]


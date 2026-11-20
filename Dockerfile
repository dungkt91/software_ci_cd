FROM node:24-alpine

ENV NODE_ENV=production
WORKDIR /app

# Install production dependencies first to make use of layer caching
COPY package.json package-lock.json ./
RUN npm ci --omit=dev

COPY src ./src

# Run as the non-root user shipped with the node image
USER node

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "fetch('http://localhost:'+(process.env.PORT||3000)+'/health').then(r=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))"

CMD ["node", "src/index.js"]

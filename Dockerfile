FROM node:20.5-alpine3.17 as BUILD_IMAGE
WORKDIR /app
COPY package.json package-lock.json ./
# install dependencies
RUN npm install --production
COPY . .
# build
RUN npm run build
# remove dev dependencies
RUN npm prune --production
FROM node:alpine
WORKDIR /app
# copy from build image
COPY --from=BUILD_IMAGE /app/package.json ./package.json
COPY --from=BUILD_IMAGE /app/node_modules ./node_modules
COPY --from=BUILD_IMAGE /app/.next ./.next
COPY --from=BUILD_IMAGE /app/public ./public

USER node

EXPOSE 3000
CMD ["npm", "run", "start"]
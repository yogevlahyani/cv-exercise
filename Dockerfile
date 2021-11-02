FROM node:16 as development

WORKDIR /app

COPY package.json ./
COPY yarn.lock ./

RUN yarn --frozen-lockfile

COPY . .

RUN yarn build

FROM node:16 as production

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /app

COPY package.json ./
COPY yarn.lock ./

RUN yarn --frozen-lockfile --production

COPY --from=development /app/dist ./dist
COPY --from=development /app/ormconfig.js ./ormconfig.js

CMD ["yarn", "start"]
FROM node:18-bullseye

ARG BACKEND_WORKING_DIR=usr/app
ENV BACKEND_WORKING_DIR=${BACKEND_WORKING_DIR}
RUN corepack enable

RUN mkdir -p /$BACKEND_WORKING_DIR;
WORKDIR /$BACKEND_WORKING_DIR
COPY ./package.json .
COPY . .

RUN npm i -g npm@latest; \
 # Install pnpm
 npm install -g pnpm; \
 pnpm --version; \
 pnpm setup; \
 mkdir -p /usr/local/share/pnpm &&\
 export PNPM_HOME="/usr/local/share/pnpm" &&\
 export PATH="$PNPM_HOME:$PATH"; \
 pnpm bin -g &&\
 # Install dependencies
 pnpm install

RUN pnpm build
EXPOSE 80
CMD ["pnpm", "start"]

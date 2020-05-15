FROM astefanutti/scratch-node:14.2.0 as node-runtime

FROM node:14.2.0 as node-build
ADD package.json yarn.lock ./app/
WORKDIR /app
RUN yarn install --prod --frozen-lockfile

FROM hasura/graphql-engine:v1.2.1.cli-migrations-v2

# Install `node` runtime
COPY --from=node-runtime /bin/node /bin/node
COPY --from=node-runtime /lib/ld-musl-*.so.1 /lib/
COPY --from=node-runtime /etc/passwd /tmp/node_etc_passwd
RUN cat /tmp/node_etc_passwd >> /etc/passwd
# Appends something like `node:x:1000:1000:Linux User,,,:/home/node:/bin/sh`
# USER node

# Copy node dependencies
COPY --from=node-build /app/node_modules /app/node_modules

# Copy node source
COPY *-process.js /app/

# Copy Procfile
COPY container.Procfile /app/

# Copy hasura migrations & metadata
COPY metadata /hasura-metadata/
COPY migrations /hasura-migrations/

# Start main process
# Note: The [cli-migrations] docker image sets WORKDIR to /tmp/hasura-project and it can't be overridden...
#  so we must `cd` into the /app folder.
CMD cd /app && \
    node /app/node_modules/.bin/nf \
        --procfile container.Procfile \
        start \
        front=1,engine=1

## Comment the command above and use the command below to
## enable an access-key and an auth-hook
## Recommended that you set the access-key as a environment variable in heroku
#CMD graphql-engine \
#    serve \
#    --server-port $PORT \
#    --access-key XXXXX \
#    --auth-hook https://myapp.com/hasura-webhook
#
# Console can be enable/disabled by the env var HASURA_GRAPHQL_ENABLE_CONSOLE

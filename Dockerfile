FROM astefanutti/scratch-node:14.2.0 as node
FROM hasura/graphql-engine:v1.2.1.cli-migrations-v2

COPY --from=node /bin/node /bin/node
COPY --from=node /lib/ld-musl-*.so.1 /lib/
COPY --from=node /etc/passwd /tmp/node_etc_passwd
RUN cat /tmp/node_etc_passwd >> /etc/passwd
# Appends something like `node:x:1000:1000:Linux User,,,:/home/node:/bin/sh`
# USER node

COPY metadata /hasura-metadata/
COPY migrations /hasura-migrations/

CMD node --version && \
    graphql-engine \
    serve \
    --server-port $PORT

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

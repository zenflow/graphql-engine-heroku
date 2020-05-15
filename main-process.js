// TODO: What if port 8080 is taken?
// TOOD: wait for graphql-engine to print "starting API server" before starting front-process
// TODO: crash if one of the child processes crashes
// TODO: ensure SIGTERM propagates to child processes

const { spawn } = require('child_process')

const { PORT } = process.env

const HASURA_PORT = 8080

const procs = [
  spawn(
    `/bin/graphql-engine serve --server-port ${HASURA_PORT}`,
    {
      shell: true,
      env: {...process.env},
    },
  ),
  spawn(
    `/bin/node front-process.js`,
    {
      shell: true,
      env: {HASURA_PORT, PORT},
    },
  ),
]

procs.forEach(proc => {
  proc.stdout.pipe(process.stdout)
  proc.stderr.pipe(process.stderr)
})

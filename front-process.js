// TODO: Delay listening until `engine` is online

const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware')

const { PORT } = process.env

// As per documentation: https://hasura.io/docs/1.0/graphql/manual/api-reference/index.html
const hasuraApiPaths = [
  '/v1/graphql',
  '/v1alpha1/graphql',
  '/v1/query',
  '/v1/version',
  '/healthz',
  '/v1alpha1/pg_dump',
  '/v1alpha1/config',
  '/v1/graphql/explain',
]

const app = express()

const proxyMiddleware = createProxyMiddleware({
  target: 'http://localhost:8080',
  changeOrigin: true,
  ws : true,
})
hasuraApiPaths.forEach(path => app.use(path, proxyMiddleware))

app.use('/', (req, res) => res.send('Hello world'))

app.listen(PORT, error => {
  if (error) {
    throw error
  }
  console.log(`Listening on port ${PORT}...`)
})

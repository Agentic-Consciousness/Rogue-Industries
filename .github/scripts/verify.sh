#!/usr/bin/env bash
# Checks for this repository on GitHub. There was no earlier pipeline, so these are the checks package.json
# defines: install from the lockfile, lint and the production build (which type checks).
# Nothing deploys and no real credentials are used.
set -euo pipefail
test "${GITHUB_SERVER_URL:?}" = 'https://github.com'
case "${GITHUB_REPOSITORY:?}" in
  HallyAus/Rogue-Industries|Agentic-Consciousness/Rogue-Industries) ;;
  *) echo "Unexpected repository: $GITHUB_REPOSITORY" >&2; exit 1 ;;
esac
test "$(git rev-parse HEAD)" = "${GITHUB_SHA:?}"
node -e 'if (process.versions.node.split(".")[0] !== "22") throw Error("Use the Node 22 runtime the project pins")'
unset VERCEL_TOKEN VERCEL_OIDC_TOKEN
export CI=1 NEXT_TELEMETRY_DISABLED=1 NODE_OPTIONS=--max-old-space-size=3072

npm ci
npm run lint
npm run build

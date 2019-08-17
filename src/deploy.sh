#!/bin/sh

REF="$1"
if [ -z "${REF}" ]; then
    echo Empty ref specified
    exit 1
fi

if [ -z "$GITHUB_TOKEN" ]; then
    echo Token invalid
    exit 1
fi

REMOTE_REPO="https://x-access-token:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"

cd "${GITHUB_WORKSPACE}" || exit 1
git config user.name "${GITHUB_ACTOR}"
git config user.email "${GITHUB_ACTOR}@users.noreply.github.com"

git remote add dist "${REMOTE_REPO}" || exit 1

if git diff --exit-code -s HEAD dist/"${GITHUB_REF}" -- . ':!node_modules'; then
    :
else
    echo HEAD outdated
    exit 1
fi

npm i
npm run build || exit 1
npm run test || exit 1

rm -rf node_modules
npm i --production
git add -f node_modules
git add .

if git commit -am "Deployed From Action ${GITHUB_ACTION}"; then
    git push -f dist HEAD:"${REF}"
    exit "$?"
else
    echo Nothing to push
    exit 0
fi

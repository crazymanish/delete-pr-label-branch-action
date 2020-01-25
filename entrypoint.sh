#!/bin/bash
set -e

if [[ -z "$GITHUB_TOKEN" ]]; then
  echo "Set the GITHUB_TOKEN env variable."
  exit 1
fi

if [[ -z "$LABEL_NAME" ]]; then
  echo "Set the LABEL_NAME env variable."
  exit 1
fi

URI="https://api.github.com"
API_HEADER="Accept: application/vnd.github.v3+json"
AUTH_HEADER="Authorization: token ${GITHUB_TOKEN}"

delete_pull_request_label_branch() {
  echo "List Labeling pull request"

  PULL_REQUESTS=$(
    curl -XGET -fsSL \
      -H "${AUTH_HEADER}" \
      -H "${API_HEADER}" \
      "${URI}/repos/${GITHUB_REPOSITORY}/issues?state=closed&labels=${LABEL_NAME}"
    )

  echo "$PULL_REQUESTS"
}

delete_pull_request_label_branch

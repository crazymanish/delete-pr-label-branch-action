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
  LABEL_PULL_REQUESTS=$(
    curl -XGET -fsSL \
      -H "${AUTH_HEADER}" \
      -H "${API_HEADER}" \
      "${URI}/repos/${GITHUB_REPOSITORY}/issues?state=closed&labels=${LABEL_NAME}"
    )

  PULL_REQUEST_URLS=$(echo "$LABEL_PULL_REQUESTS" | jq '[.[] | .pull_request.url]')
  echo "$PULL_REQUEST_URLS"

  for PULL_REQUEST_URL in $PULL_REQUEST_URLS; do
    echo "Fetching pull request details: $(echo ${PULL_REQUEST_URL})"
    PULL_REQUEST_DETAILS=$(
      curl -XGET -fsSL \
        -H "${AUTH_HEADER}" \
        -H "${API_HEADER}" \
        "$(echo ${PULL_REQUEST_URL})"
    )

    echo "$PULL_REQUEST_DETAILS"

  done
}

delete_pull_request_label_branch

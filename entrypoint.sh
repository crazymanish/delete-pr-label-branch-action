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

  PULL_REQUEST_URLS=$(echo "$LABEL_PULL_REQUESTS" | jq '.[] | .pull_request.url')
  echo "$PULL_REQUEST_URLS"

  for URL in $PULL_REQUEST_URLS; do
    PULL_REQUEST_URL="$(echo "$URL")"
    echo "Fetching pull request details: ${PULL_REQUEST_URL}"
    PULL_REQUEST_DETAILS=$(
      curl -XGET -fsSL \
        -H "${AUTH_HEADER}" \
        -H "${API_HEADER}" \
        "${PULL_REQUEST_URL}"
    )
    ISSUE_URL=$(echo "$PULL_REQUEST_DETAILS" | jq '.issue_url')
    REPO_URL=$(echo "$PULL_REQUEST_DETAILS" | jq '.head.repo.owner.repos_url')
    HEAD_REF=$(echo "$PULL_REQUEST_DETAILS" | jq '.head.ref')
    echo "$ISSUE_URL"
    echo "$REPO_URL"
    echo "$HEAD_REF"
  done
}

delete_pull_request_label_branch

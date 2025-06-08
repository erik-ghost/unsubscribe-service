#!/bin/bash

BASE_URL="http://localhost:3000/unsubscribe"

function check_redirect() {
  UUID=$1
  KEY=$2
  NEWSLETTER=$3

  URL="$BASE_URL?uuid=$UUID&key=$KEY&newsletter=$NEWSLETTER"
  RESPONSE=$(curl -s -D - -o /dev/null "$URL")
  STATUS_CODE=$(echo "$RESPONSE" | grep HTTP | awk '{print $2}')
  LOCATION_HEADER=$(echo "$RESPONSE" | grep -i "^location:" | tr -d '\r')

  EXPECTED_LOCATION="http://localhost:3000/?uuid=$UUID&key=$KEY&newsletter=$NEWSLETTER&action=unsubscribe"

  if [ "$STATUS_CODE" == "302" ] && [ "$LOCATION_HEADER" == "Location: $EXPECTED_LOCATION" ]; then
    echo "PASS: 302 redirect test with all params"
  else
    echo "FAIL: 302 redirect test with all params"
    echo "  Status: $STATUS_CODE"
    echo "  Location: $LOCATION_HEADER"
    exit 1
  fi
}

function check_bad_request() {
  URL=$1
  RESPONSE=$(curl -s -D - -o /dev/null "$URL")
  STATUS_CODE=$(echo "$RESPONSE" | grep HTTP | awk '{print $2}')
  if [ "$STATUS_CODE" == "400" ]; then
    echo "PASS: 400 bad request test with missing params"
  else
    echo "FAIL: 400 bad request test with missing params"
    echo "  Status: $STATUS_CODE"
    exit 1
  fi
}

UUID="fbb93683-b076-4eee-a7e3-d6b912b6dcd8"
KEY="43eef6c0e3957159b8e972ca8ab163d90831b7f1e7754b0d42e418c8a08883b1"
NEWSLETTER="ba5bbf3a-b3b3-4939-9d25-4e71d365c2d6"

echo "Running unsubscribe integration tests..."

check_redirect "$UUID" "$KEY" "$NEWSLETTER"
check_bad_request "$BASE_URL"
check_bad_request "$BASE_URL?uuid=$UUID&key=$KEY"
check_bad_request "$BASE_URL?key=$KEY&newsletter=$NEWSLETTER"
check_bad_request "$BASE_URL?uuid=$UUID&newsletter=$NEWSLETTER"

echo "All tests passed."
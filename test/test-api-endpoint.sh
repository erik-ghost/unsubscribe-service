#!/bin/bash

# Test script to check /unsubscribe endpoint returns HTTP 302 and correct Location header

# Sample query parameters
UUID="fbb93683-b076-4eee-a7e3-d6b912b6dcd8"
KEY="43eef6c0e3957159b8e972ca8ab163d90831b7f1e7754b0d42e418c8a08883b1"
NEWSLETTER="ba5bbf3a-b3b3-4939-9d25-4e71d365c2d6"
URL="http://localhost:3000/unsubscribe?uuid=$UUID&key=$KEY&newsletter=$NEWSLETTER"

echo "Testing GET $URL"

RESPONSE=$(curl -s -D - -o /dev/null "$URL")
STATUS_CODE=$(echo "$RESPONSE" | grep HTTP | awk '{print $2}')
LOCATION_HEADER=$(echo "$RESPONSE" | grep -i "^location:" | tr -d '\r')

EXPECTED_LOCATION="http://localhost:3000/?uuid=$UUID&key=$KEY&newsletter=$NEWSLETTER&action=unsubscribe"

if [ "$STATUS_CODE" -eq 302 ] && [ "$LOCATION_HEADER" = "Location: $EXPECTED_LOCATION" ]; then
  echo "Test Passed: Received HTTP 302 with correct Location header"
  exit 0
else
  echo "Test Failed:"
  echo "Expected HTTP 302 with Location: $EXPECTED_LOCATION"
  echo "Got status code: $STATUS_CODE"
  echo "Got Location header: $LOCATION_HEADER"
  exit 1
fi
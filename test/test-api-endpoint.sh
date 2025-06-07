#!/bin/bash

# Simple test script to check /unsubscribe endpoint returns HTTP 200

URL="http://localhost:3000/unsubscribe"

echo "Testing GET $URL"

STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$URL")

if [ "$STATUS_CODE" -eq 200 ]; then
  echo "Test Passed: Received HTTP 200"
  exit 0
else
  echo "Test Failed: Expected HTTP 200 but got $STATUS_CODE"
  exit 1
fi
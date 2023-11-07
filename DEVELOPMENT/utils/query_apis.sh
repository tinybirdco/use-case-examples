#!/bin/bash

# Function to display usage information
usage() {
  echo "Usage: $0 --token <token> --nreq <number_of_requests> [--host <host>]"
  echo "  --token    Authorization token for accessing the endpoints."
  echo "  --nreq     Number of times requests will be made to each endpoint."
  echo "  --host     The host to send requests to. Defaults to 'api.tinybird.co'."
  echo "  -h         Display this help message."
}

# Function to draw a progress bar
draw_progress_bar() {
  # Calculate percentage
  local __percent=$1
  local __filled=$(printf "%.0f" $(echo "scale=2; $__percent / 100 * 20" | bc))

  # Draw progress bar
  printf "["
  for i in $(seq 1 20); do
    if [ $i -le $__filled ]; then 
      printf "#"
    else
      printf " "
    fi
  done
  printf "] %.2f%%\r" "$__percent"
}

# Initialize parameters
TOKEN=""
NUM_REQUESTS=""
HOST="https://api.tinybird.co"

# Parse command line options
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --token) TOKEN="$2"; shift ;;
    --nreq) NUM_REQUESTS="$2"; shift ;;
    --host) HOST="$2"; shift ;;
    -h) usage; exit 0 ;;
    *) echo "Unknown option: $1"; usage; exit 1 ;;
  esac
  shift
done

# Check for mandatory parameters
if [ -z "$TOKEN" ]; then
  echo "Error: token is required."
  usage
  exit 1
fi

if [ -z "$NUM_REQUESTS" ]; then
  echo "Error: nreq (number of requests) is required."
  usage
  exit 1
fi

# Ensure that number_of_requests is a number
if ! [[ "$NUM_REQUESTS" =~ ^[0-9]+$ ]]; then
  echo "Error: nreq must be a positive integer."
  usage
  exit 1
fi

# List of endpoints
endpoints=("top_locations" "top_pages" "top_sources" "top_browsers" "top_devices" "kpis" "trend")

# Total number of requests to be made
TOTAL_REQUESTS=$((NUM_REQUESTS * ${#endpoints[@]}))

# Initialize counter for completed requests
COMPLETED=0

# Perform requests
for i in $(seq 1 $NUM_REQUESTS); do
  for endpoint in "${endpoints[@]}"; do
    curl -s "$HOST/v0/pipes/${endpoint}.json?limit=50&token=$TOKEN" > /dev/null

    # Increment the completed requests counter
    ((COMPLETED++))

    # Calculate and draw the progress
    PERCENT=$(echo "scale=2; ($COMPLETED / $TOTAL_REQUESTS) * 100" | bc)
    draw_progress_bar $PERCENT
  done
done

# Print a new line after the progress bar reaches 100%
echo ""

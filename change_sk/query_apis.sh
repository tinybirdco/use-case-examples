#!/bin/bash

# Function to display usage information
usage() {
  echo "Usage: $0 <token> <number_of_requests> [host]"
  echo "    <token>: Authorization token for accessing the endpoints."
  echo "    <number_of_requests>: Number of times requests will be made to each endpoint."
  echo "    [host] (optional): The host to send requests to. Defaults to 'api.tinybird.co'."
}

# Function to draw a progress bar
draw_progress_bar() {
  # Calculate percentage
  local __percent=$1
  local __filled=$(printf "%.0f" $(echo "scale=2; $__percent / 100 * 20" | bc))

  # Draw progress bar
  printf "["
  for i in $(seq 1 20); do
    [ $i -le $__filled ] && printf "#" || printf " "
  done
  printf "] %.2f%%\r" "$__percent"
}

# Check if enough arguments have been provided
if [ "$#" -lt 2 ]; then
  echo "Incorrect number of arguments."
  usage
  exit 1
fi

# Retrieve arguments
TOKEN=$1
NUM_REQUESTS=$2
HOST=${3:-api.tinybird.co}  # Default host is api.tinybird.co if not provided

# List of endpoints
endpoints=("top_locations" "top_pages" "top_sources" "top_browsers" "top_devices" "kpis" "trend")

# Total number of requests to be made
TOTAL_REQUESTS=$(($NUM_REQUESTS * ${#endpoints[@]}))

# Initialize counter for completed requests
COMPLETED=0

# Perform requests
for i in $(seq 1 $NUM_REQUESTS); do
  for endpoint in "${endpoints[@]}"; do
    curl -s "https://$HOST/v0/pipes/${endpoint}.json?limit=50&token=$TOKEN" > /dev/null

    # Increment the completed requests counter
    ((COMPLETED++))

    # Calculate and draw the progress
    PERCENT=$(echo "scale=2; ($COMPLETED / $TOTAL_REQUESTS) * 100" | bc)
    draw_progress_bar $PERCENT
  done
done

# Print a new line after the progress bar reaches 100%
echo ""

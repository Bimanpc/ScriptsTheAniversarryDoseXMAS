# GET request to a URL
curl https://api.example.com/data

# GET with output to file
curl -o output.json https://api.example.com/file.json

# POST with JSON data
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"key":"value"}' \
  https://api.example.com/endpoint

# Request with headers
curl -H "Authorization: Bearer YOUR_TOKEN" \
  https://api.example.com/protected

# PUT/PATCH requests
curl -X PUT -d 'data here' https://api.example.com/resource

# Download with progress bar
curl -O https://example.com/largefile.zip

# Debug mode (verbose)
curl -v https://api.example.com/data

# Limit rate and show progress
curl --limit-rate 100k --progress-bar https://example.com/file

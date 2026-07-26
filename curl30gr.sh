# Check if the local server is running
curl http://localhost:3000

# With verbose output (shows headers)
curl -v http://localhost:3000

# Save response to a file
curl http://localhost:3000 -o output.html

# GET request with custom headers
curl -H "Authorization: Bearer token123" http://localhost:3000/api/data

# POST request with JSON data
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{"name":"test","value":123}' \
  http://localhost:3000/api/endpoint

# POST form data
curl -X POST \
  -F "file=@/path/to/file.txt" \
  -F "description=test upload" \
  http://localhost:3000/upload

# PUT/PATCH/DELETE requests
curl -X PUT -H "Content-Type: application/json" -d '{"updated":true}' http://localhost:3000/resource/1
curl -X DELETE http://localhost:3000/resource/1

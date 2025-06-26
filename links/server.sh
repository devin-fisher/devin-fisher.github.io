#!/bin/sh
# ****** TO RUN SERVER *******
# wget -qO- https://devin-fisher.github.io/links/server.sh | sh

# Function to log error and exit
fail() {
  echo "ERROR: $1" >&2
  exit 1
}

# Detect platform and install python3 if missing
if ! command -v python3 >/dev/null 2>&1; then
  echo "Python3 not found. Attempting to install..."

  if [ -f /etc/alpine-release ]; then
    echo "Detected Alpine Linux"
    apk add --no-cache python3 || fail "Failed to install python3 with apk"
  elif [ -f /etc/lsb-release ] || grep -qi ubuntu /etc/os-release 2>/dev/null; then
    echo "Detected Ubuntu"
    apt update && apt install -y python3 || fail "Failed to install python3 with apt"
  else
    fail "Unsupported OS. Only Alpine and Ubuntu are supported."
  fi
fi

# Write Python HTTP logger script
cat > /tmp/http_logger.py <<'EOF'
from http.server import BaseHTTPRequestHandler, HTTPServer
import base64

class RequestLogger(BaseHTTPRequestHandler):
    def _log_request(self):
        print(f"\n--- {self.command} {self.path} {self.request_version} ---")
        print("Headers:")
        auth_header = self.headers.get('Authorization')
        for key, value in self.headers.items():
            print(f"  {key}: {value}")

        content_length = int(self.headers.get('Content-Length', 0))
        if content_length:
            body = self.rfile.read(content_length).decode('utf-8', errors='replace')
            print("\nBody:")
            print(body)
        else:
            body = ""

        if auth_header and auth_header.startswith('Basic '):
            encoded = auth_header.split(' ', 1)[1].strip()
            try:
                decoded = base64.b64decode(encoded).decode('utf-8')
                print("\nDecoded Basic Auth:")
                print(f"  {decoded}")
            except Exception as e:
                print(f"\nFailed to decode Authorization header: {e}")

        print("--- END REQUEST ---\n")

    def do_GET(self):
        self._log_request()
        self.send_response(200)
        self.end_headers()

    def do_POST(self):
        self._log_request()
        self.send_response(200)
        self.end_headers()

    def log_message(self, format, *args):
        return  # Suppress default HTTP logs

if __name__ == "__main__":
    server_address = ('0.0.0.0', 8080)
    print(f"Listening on http://{server_address[0]}:{server_address[1]}")
    HTTPServer(server_address, RequestLogger).serve_forever()
EOF

# Run the server
exec python3 /tmp/http_logger.py

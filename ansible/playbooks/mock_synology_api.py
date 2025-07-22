import http.server
import socketserver
import json
from urllib.parse import urlparse, parse_qs

class MockSynologyAPI(http.server.SimpleHTTPRequestHandler):
    def do_POST(self):
        self.send_response(200)
        self.send_header("Content-type", "application/json")
        self.end_headers()

        parsed_path = urlparse(self.path)
        query_params = parse_qs(parsed_path.query)

        api = query_params.get("api", [None])[0]
        method = query_params.get("method", [None])[0]

        response = {"success": False, "data": {}}

        if api == "SYNO.Core.User" and method == "create":
            response = {"success": True, "data": {"name": query_params.get("name", [None])[0]}}
        elif api == "SYNO.Core.User" and method == "delete":
            response = {"success": True}
        elif api == "SYNO.Core.Group" and method == "create":
            response = {"success": True, "data": {"name": query_params.get("name", [None])[0]}}
        elif api == "SYNO.Core.Group" and method == "delete":
            response = {"success": True}
        elif api == "SYNO.FileStation.CreateFolder" and method == "create":
            response = {"success": True, "data": {"folders": [{"name": query_params.get("name", [None])[0]}]}}
        elif api == "SYNO.FileStation.Delete" and method == "start":
            response = {"success": True}

        self.wfile.write(json.dumps(response).encode("utf-8"))

PORT = 8000
Handler = MockSynologyAPI

with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print("serving at port", PORT)
    httpd.serve_forever()

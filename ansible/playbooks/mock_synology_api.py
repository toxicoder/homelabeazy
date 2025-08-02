import http.server
import socketserver
import json
from urllib.parse import urlparse, parse_qs
import threading

class SynologyState:
    def __init__(self):
        self.users = {}
        self.groups = {}
        self.folders = {}
        self.sid = "mock_sid"

state = SynologyState()

class MockSynologyAPI(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        self.handle_request()

    def do_POST(self):
        self.handle_request()

    def handle_request(self):
        self.send_response(200)
        self.send_header("Content-type", "application/json")
        self.end_headers()

        parsed_path = urlparse(self.path)
        query_params = parse_qs(parsed_path.query)

        api = query_params.get("api", [None])[0]
        method = query_params.get("method", [None])[0]

        response = {"success": False, "data": {}}

        if api == "SYNO.API.Auth" and method == "login":
            response = {"success": True, "data": {"sid": state.sid}}
        elif api == "SYNO.Core.User" and method == "list":
            response = {"success": True, "data": {"users": list(state.users.values())}}
        elif api == "SYNO.Core.User" and method == "create":
            name = query_params.get("name", [None])[0]
            if name not in state.users:
                state.users[name] = {"name": name, "email": query_params.get("email", [None])[0]}
            response = {"success": True, "data": {"name": name}}
        elif api == "SYNO.Core.User" and method == "delete":
            name = query_params.get("name", [None])[0]
            if name in state.users:
                del state.users[name]
            response = {"success": True}
        elif api == "SYNO.Core.Group" and method == "list":
            response = {"success": True, "data": {"groups": list(state.groups.values())}}
        elif api == "SYNO.Core.Group" and method == "create":
            name = query_params.get("name", [None])[0]
            if name not in state.groups:
                state.groups[name] = {"name": name, "description": query_params.get("description", [None])[0]}
            response = {"success": True, "data": {"name": name}}
        elif api == "SYNO.Core.Group" and method == "delete":
            name = query_params.get("name", [None])[0]
            if name in state.groups:
                del state.groups[name]
            response = {"success": True}
        elif api == "SYNO.FileStation.List" and method == "get_info":
            response = {"success": True, "data": {"shares": list(state.folders.values())}}
        elif api == "SYNO.FileStation.CreateFolder" and method == "create":
            name = query_params.get("name", [None])[0]
            path = query_params.get("folder_path", [None])[0]
            folder_path = f"{path}/{name}".replace('//', '/')
            if folder_path not in state.folders:
                state.folders[folder_path] = {"name": name, "path": folder_path}
            response = {"success": True, "data": {"folders": [{"name": name, "path": folder_path}]}}
        elif api == "SYNO.FileStation.Delete" and method == "start":
            path = query_params.get("path", [None])[0]
            if path in state.folders:
                del state.folders[path]
            response = {"success": True}

        self.wfile.write(json.dumps(response).encode("utf-8"))

PORT = 8000
Handler = MockSynologyAPI

with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print("serving at port", PORT)
    httpd.serve_forever()

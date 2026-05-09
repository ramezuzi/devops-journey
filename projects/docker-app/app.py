from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import os
import redis
import psycopg2

REDIS_HOST = os.environ.get('REDIS_HOST', 'redis')
DB_HOST = os.environ.get('DB_HOST', 'postgres')
DB_PASSWORD = os.environ.get('DB_PASSWORD', 'password')

def get_redis():
    return redis.Redis(host=REDIS_HOST, port=6379, decode_responses=True)

def get_db():
    return psycopg2.connect(
        host=DB_HOST, database='appdb',
        user='appuser', password=DB_PASSWORD
    )

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/health':
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            self.wfile.write(json.dumps({"status": "healthy"}).encode())

        elif self.path == '/cache':
            r = get_redis()
            count = r.incr('visits')
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            self.wfile.write(json.dumps({"visits": count}).encode())

        else:
            self.send_response(200)
            self.send_header('Content-Type', 'text/plain')
            self.end_headers()
            self.wfile.write(b"Hello from 3-tier app!")

    def log_message(self, format, *args):
        pass

port = int(os.environ.get('PORT', 8080))
print(f"Starting on port {port}")
HTTPServer(('0.0.0.0', port), Handler).serve_forever()

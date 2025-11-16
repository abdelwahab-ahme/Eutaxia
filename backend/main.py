from fastapi import FastAPI, WebSocket, WebSocketDisconnect, Request, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import sqlite3, time, requests, re, json
from typing import List, Dict, Optional
from twilio.rest import Client
from dotenv import load_dotenv
import asyncio
import time
from fastapi import FastAPI
import os, random

# تحميل متغيرات البيئة
load_dotenv()

app = FastAPI()

# تخزين الـ OTP مؤقتًا (في ذاكرة السيرفر)
otp_store = {}

# إعداد Twilio
TWILIO_ACCOUNT_SID = os.getenv("TWILIO_ACCOUNT_SID")
TWILIO_AUTH_TOKEN = os.getenv("TWILIO_AUTH_TOKEN")
TWILIO_PHONE_NUMBER = os.getenv("TWILIO_PHONE_NUMBER")

client = Client(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN)
print(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN, TWILIO_PHONE_NUMBER)

# ---------------- CORS ----------------
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ---------------- Database ----------------
conn = sqlite3.connect("taxi.db", check_same_thread=False)
cursor = conn.cursor()

# Users Table
cursor.execute("""
CREATE TABLE IF NOT EXISTS users(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    phone TEXT UNIQUE,
    role TEXT,
    car_model INTEGER,
    car_type TEXT,
    status TEXT DEFAULT 'offline'
)
""")

# Trips Table
cursor.execute("""
CREATE TABLE IF NOT EXISTS trips(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    client_id INTEGER,
    driver_id INTEGER,
    from_lat REAL,
    from_lng REAL,
    to_lat REAL,
    to_lng REAL,
    price REAL,
    status TEXT,
    payment_method TEXT,
    rating INTEGER
)
""")

# Drivers Location Table
cursor.execute("""
CREATE TABLE IF NOT EXISTS drivers_location(
    driver_id INTEGER PRIMARY KEY,
    lat REAL,
    lng REAL,
    timestamp REAL
)
""")

conn.commit()

# ---------------- Models ----------------
class User(BaseModel):
    name: str
    phone: str
    role: str
    car_model: Optional[int] = None
    car_type: Optional[str] = None

class Trip(BaseModel):
    client_id: int
    driver_id: Optional[int] = None
    from_lat: float
    from_lng: float
    to_lat: float
    to_lng: float
    price: float
    status: str = "pending"
    payment_method: Optional[str] = None
    rating: Optional[int] = None

class Location(BaseModel):
    driver_id: int
    lat: float
    lng: float

# نموذج الطلبات
class PhoneRequest(BaseModel):
    phone: str

class VerifyRequest(BaseModel):
    phone: str
    code: str



# 🔹 إرسال OTP
@app.post("/send-otp")
def send_otp(req: PhoneRequest):
    phone = req.phone
    otp = str(random.randint(1000, 9999))
    otp_store[phone] = otp
    print(f"OTP for {phone}: {otp}")  # تظهر في الكونسول فقط
    return {"status": "success", "message": f"OTP generated for {phone}"}


# 🔹 التحقق من OTP
@app.post("/verify-otp")
def verify_otp(req: VerifyRequest):
    phone = req.phone
    code = req.code

    if otp_store.get(phone) == code:
        del otp_store[phone]
        return {"status": "success", "message": "Phone verified"}
    else:
        raise HTTPException(status_code=400, detail="Invalid OTP code")

# ---------------- Register ----------------
@app.post("/register")
def register_user(user: User):
    try:
        cursor.execute(
            "INSERT INTO users (name, phone, role, car_model, car_type, status) VALUES (?, ?, ?, ?, ?, 'offline')",
            (user.name, user.phone, user.role, user.car_model, user.car_type)
        )
        conn.commit()
        return {"status": "success", "user_id": cursor.lastrowid}
    except sqlite3.IntegrityError:
        return {"status": "error", "message": "رقم الهاتف موجود بالفعل"}

# ---------------- Login ----------------
PHONE_RE = re.compile(r"^01[0125]\d{8}$")

@app.post("/login")
async def login_user(request: Request):
    try:
        data = await request.json()
        phone = data.get("phone")
        if not phone:
            return {"status": "error", "message": "يرجى إدخال رقم الهاتف"}
        phone = str(phone).strip()
        if not PHONE_RE.match(phone):
            return {"status": "error", "message": "يرجى إدخال رقم هاتف مصري صالح"}

        cursor.execute("SELECT id, name, role FROM users WHERE phone=?", (phone,))
        row = cursor.fetchone()

        if row:
            cursor.execute("UPDATE users SET status='online' WHERE id=?", (row[0],))
            conn.commit()
            return {"status": "success", "user_id": row[0], "name": row[1], "role": row[2]}
        else:
            cursor.execute("INSERT INTO users (name, phone, role, status) VALUES (?, ?, ?, 'online')",
                           ("مستخدم جديد", phone, "client"))
            conn.commit()
            return {"status": "success", "user_id": cursor.lastrowid, "name": "مستخدم جديد", "role": "client"}

    except Exception as e:
        return {"status": "error", "message": str(e)}

# ---------------- Trips ----------------
@app.post("/trips")
def create_trip(trip: Trip):
    cursor.execute("""
        INSERT INTO trips (client_id, from_lat, from_lng, to_lat, to_lng, price, status)
        VALUES (?, ?, ?, ?, ?, ?, ?)
    """, (trip.client_id, trip.from_lat, trip.from_lng, trip.to_lat, trip.to_lng, trip.price, trip.status))
    conn.commit()
    trip_id = cursor.lastrowid

    # بث الرحلة الجديدة إلى السائقين المتصلين
    trip_data = dict(trip.dict())
    trip_data["trip_id"] = trip_id
    import asyncio
    asyncio.create_task(manager.broadcast_to_drivers({"event": "new_trip", "data": trip_data}))

    return {"status": "success", "trip_id": trip_id}

@app.get("/trips/pending")
def get_pending_trips():
    cursor.execute("""
        SELECT trips.*, c.name as client_name, d.name as driver_name
        FROM trips
        LEFT JOIN users c ON trips.client_id = c.id
        LEFT JOIN users d ON trips.driver_id = d.id
        WHERE trips.status='pending'
    """)
    rows = cursor.fetchall()
    return {"trips": [dict(zip([column[0] for column in cursor.description], row)) for row in rows]}

@app.post("/trips/{trip_id}/complete")
def complete_trip(trip_id: int, payload: dict):
    cursor.execute("UPDATE trips SET status=?, payment_method=? WHERE id=?",
                   (payload.get("status"), payload.get("payment_method"), trip_id))
    conn.commit()
    return {"status": "success"}

@app.post("/trips/{trip_id}/rate")
def rate_trip(trip_id: int, payload: dict):
    cursor.execute("UPDATE trips SET rating=? WHERE id=?", (payload.get("rating"), trip_id))
    conn.commit()
    return {"status": "success"}

# ---------------- Driver Location ----------------




@app.post("/drivers/{driver_id}/location")
async def update_driver_location(driver_id: int, loc: Location):
    cursor.execute("""
        INSERT OR REPLACE INTO drivers_location (driver_id, lat, lng, timestamp)
        VALUES (?, ?, ?, ?)
    """, (driver_id, loc.lat, loc.lng, time.time()))
    conn.commit()

    # بث الموقع الجديد لكل العملاء المتصلين (بشكل متزامن صحيح)
    await manager.broadcast_to_clients({
        "event": "driver_location_update",
        "driver_id": driver_id,
        "lat": loc.lat,
        "lng": loc.lng
    })

    return {"status": "success"}


@app.get("/drivers/location")
def get_all_locations():
    cursor.execute("SELECT * FROM drivers_location")
    rows = cursor.fetchall()
    return {"locations": [dict(zip([column[0] for column in cursor.description], row)) for row in rows]}


# ---------------- WebSocket ----------------
class ConnectionManager:
    def __init__(self):
        self.clients: Dict[int, WebSocket] = {}
        self.drivers: Dict[int, WebSocket] = {}

    async def connect_client(self, user_id: int, websocket: WebSocket):
        await websocket.accept()
        self.clients[user_id] = websocket

    async def connect_driver(self, driver_id: int, websocket: WebSocket):
        await websocket.accept()
        self.drivers[driver_id] = websocket
        cursor.execute("UPDATE users SET status='online' WHERE id=?", (driver_id,))
        conn.commit()

    def disconnect(self, user_id: int):
        if user_id in self.clients:
            del self.clients[user_id]
        if user_id in self.drivers:
            del self.drivers[user_id]
        cursor.execute("UPDATE users SET status='offline' WHERE id=?", (user_id,))
        conn.commit()

    async def broadcast_to_clients(self, message: dict):
        for ws in self.clients.values():
            await ws.send_json(message)

    async def broadcast_to_drivers(self, message: dict):
        for ws in self.drivers.values():
            await ws.send_json(message)

manager = ConnectionManager()

@app.websocket("/ws/client/{user_id}")
async def websocket_client(websocket: WebSocket, user_id: int):
    await manager.connect_client(user_id, websocket)
    try:
        while True:
            data = await websocket.receive_json()
            await manager.broadcast_to_drivers(data)
    except WebSocketDisconnect:
        manager.disconnect(user_id)

@app.websocket("/ws/driver/{driver_id}")
async def websocket_driver(websocket: WebSocket, driver_id: int):
    await manager.connect_driver(driver_id, websocket)
    try:
        while True:
            data = await websocket.receive_json()
            await manager.broadcast_to_clients(data)
    except WebSocketDisconnect:
        manager.disconnect(driver_id)

# ---------------- Google Route ----------------
GOOGLE_API_KEY = "YOUR_GOOGLE_API_KEY"

@app.get("/route")
def get_route(from_lat: float, from_lng: float, to_lat: float, to_lng: float):
    url = f"https://maps.googleapis.com/maps/api/directions/json?origin={from_lat},{from_lng}&destination={to_lat},{to_lng}&key={GOOGLE_API_KEY}"
    r = requests.get(url)
    if r.status_code == 200:
        data = r.json()
        if data["status"] == "OK":
            route = data["routes"][0]["overview_polyline"]["points"]
            distance = data["routes"][0]["legs"][0]["distance"]["text"]
            duration = data["routes"][0]["legs"][0]["duration"]["text"]
            return {"route": route, "distance": distance, "duration": duration}
    return {"error": "لم يتم العثور على طريق"}

# ---------------- Run ----------------
if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)

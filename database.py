import sqlite3
import random
from datetime import datetime

def generate_report_number():
    year = datetime.now().strftime("%y")
    random_num = random.randint(10000, 99999)
    return f"{year}-{random_num}"


DB_NAME = "reports.db"

def init_db():
    conn = sqlite3.connect(DB_NAME)
    c = conn.cursor()

    c.execute("""
        CREATE TABLE IF NOT EXISTS reports (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            report_number TEXT,
            description TEXT,
            type TEXT,
            authority TEXT,
            location TEXT,
            date TEXT,
            time TEXT
        )
    """)

    conn.commit()
    conn.close()



def save_report(description, report_type, authority, location, date, time):
    conn = sqlite3.connect(DB_NAME)
    c = conn.cursor()

    c.execute("""
        INSERT INTO reports (description, type, authority, location, date, time)
        VALUES (?, ?, ?, ?, ?, ?)
    """, (description, report_type, authority, location, date, time))

    conn.commit()
    new_id = c.lastrowid
    conn.close()
    return new_id



def get_reports():
    conn = sqlite3.connect(DB_NAME)
    c = conn.cursor()

    c.execute("""
        SELECT id, description, type, authority, location, date, time
        FROM reports
        ORDER BY id DESC
    """)

    rows = c.fetchall()
    conn.close()

    
    return [
        {
            "id": r[0],
            "description": r[1],
            "type": r[2],
            "authority": r[3],
            "location": r[4],
            "date": r[5],
            "time": r[6]
        }
        for r in rows
    ]

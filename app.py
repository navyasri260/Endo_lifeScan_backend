print("🔥 CLEAN SERVER STARTED 🔥", flush=True)

import tensorflow as tf
from tensorflow.keras.preprocessing import image
from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS
import os, shutil, uuid, random
import numpy as np
import smtplib
from email.mime.text import MIMEText
from datetime import datetime, timedelta
import requests

from utils.heatmap import generate_heatmap, overlay_heatmap

print("🚀 BACKEND FILE LOADED", flush=True)

# 🔐 AUTH
import mysql.connector
from werkzeug.security import generate_password_hash, check_password_hash

app = Flask(__name__)
CORS(app)

@app.before_request
def log_every_request():
    print("➡️ REQUEST:", request.method, request.path, flush=True)

# ==============================
# EMAIL CONFIG
# ==============================

EMAIL_ADDRESS = os.getenv("EMAIL_ADDRESS") or "endolifescan@gmail.com"
EMAIL_PASSWORD = os.getenv("EMAIL_PASSWORD") or "gsxc wooq etsl bbiw"

def send_otp_email(to_email, otp):

    msg = MIMEText(f"Your EndoLifeScan OTP is {otp}. It is valid for 10 minutes.")
    msg["Subject"] = "EndoLifeScan Password Reset"
    msg["From"] = EMAIL_ADDRESS
    msg["To"] = to_email

    try:
        server = smtplib.SMTP("smtp.gmail.com", 587, timeout=30)
        server.starttls()
        server.login(EMAIL_ADDRESS, EMAIL_PASSWORD)
        server.send_message(msg)
        server.quit()
        return True

    except Exception as e:
        print("SMTP ERROR:", e, flush=True)
        return False


# ==============================
# FILE STORAGE
# ==============================

BASE_UPLOAD_FOLDER = "uploads"
ACCEPTED_FOLDER = os.path.join(BASE_UPLOAD_FOLDER, "accepted")

os.makedirs(BASE_UPLOAD_FOLDER, exist_ok=True)
os.makedirs(ACCEPTED_FOLDER, exist_ok=True)


# ==============================
# SERVE UPLOADED HEATMAP IMAGES
# ==============================

@app.route("/uploads/<path:filename>")
def serve_upload(filename):
    return send_from_directory(BASE_UPLOAD_FOLDER, filename)


# ==============================
# DATABASE
# ==============================

def get_db_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="endo_lifescan"
    )


# ==============================
# LOAD CNN MODEL
# ==============================

CNN_MODEL_PATH = "models/endo_cnn.h5"

if not os.path.exists(CNN_MODEL_PATH):
    raise FileNotFoundError("❌ CNN model not found. Run train_model.py first.")

cnn_model = tf.keras.models.load_model(CNN_MODEL_PATH, compile=False)

cnn_model.build((None, 224, 224, 3))

_ = cnn_model(tf.zeros((1, 224, 224, 3)))

print("✅ CNN MODEL LOADED AND BUILT", flush=True)

print("MODEL LAYERS:")
for i, layer in enumerate(cnn_model.layers):
    print(i, layer.name, layer.__class__.__name__)


# ==============================
# HOME
# ==============================

@app.route("/")
def home():
    return "EndoLifeScan backend running"


# ==============================
# SIGNUP
# ==============================

@app.route("/signup", methods=["POST"])
def signup():

    data = request.json
    full_name = data.get("full_name")
    email = data.get("email")
    password = data.get("password")

    if not all([full_name, email, password]):
        return jsonify({"status": "error", "message": "All fields required"}), 400

    db = get_db_connection()
    cursor = db.cursor(dictionary=True)

    cursor.execute("SELECT id FROM users WHERE email=%s", (email,))
    if cursor.fetchone():
        cursor.close()
        db.close()
        return jsonify({"status": "error", "message": "Email already exists"}), 409

    hashed_password = generate_password_hash(password)

    cursor.execute(
        "INSERT INTO users (full_name, email, password_hash) VALUES (%s,%s,%s)",
        (full_name, email, hashed_password)
    )

    db.commit()
    cursor.close()
    db.close()

    return jsonify({"status": "success", "message": "Account created"}), 201


# ==============================
# LOGIN
# ==============================

@app.route("/login", methods=["POST"])
def login():

    data = request.json
    email = data.get("email")
    password = data.get("password")

    db = get_db_connection()
    cursor = db.cursor(dictionary=True)

    cursor.execute("SELECT id, full_name, password_hash FROM users WHERE email=%s", (email,))
    user = cursor.fetchone()

    cursor.close()
    db.close()

    if not user:
        return jsonify({"status": "error", "message": "User not found"}), 404

    if not check_password_hash(user["password_hash"], password):
        return jsonify({"status": "error", "message": "Invalid password"}), 401

    return jsonify({
        "status": "success",
        "user": {
            "id": user["id"],
            "full_name": user["full_name"],
            "email": email
        }
    }), 200

# ==============================
# CHANGE PASSWORD
# ==============================
@app.route("/change-password", methods=["PUT"])
def change_password():

    data = request.json
    email = data.get("email")
    current_password = data.get("current_password")
    new_password = data.get("new_password")

    db = get_db_connection()
    cursor = db.cursor(dictionary=True)

    cursor.execute("SELECT password_hash FROM users WHERE email=%s", (email,))
    user = cursor.fetchone()

    if not user:
        return jsonify({"status": "error", "message": "User not found"}), 404

    if not check_password_hash(user["password_hash"], current_password):
        return jsonify({"status": "error", "message": "Current password incorrect"}), 400

    new_hash = generate_password_hash(new_password)

    cursor.execute("UPDATE users SET password_hash=%s WHERE email=%s", (new_hash, email))

    db.commit()

    return jsonify({"status": "success", "message": "Password updated successfully"}), 200

# ==============================
# FORGOT PASSWORD
# ==============================
@app.route("/forgot-password", methods=["POST"])
def forgot_password():

    data = request.json
    email = data.get("email")

    db = get_db_connection()
    cursor = db.cursor(dictionary=True)

    cursor.execute("SELECT id FROM users WHERE email=%s", (email,))
    user = cursor.fetchone()

    if not user:
        return jsonify({"status": "error", "message": "User not found"}), 404

    otp = str(random.randint(100000, 999999))
    expiry = datetime.now() + timedelta(minutes=10)

    cursor.execute("DELETE FROM password_resets WHERE email=%s", (email,))
    cursor.execute(
        "INSERT INTO password_resets (email, otp, expires_at, created_at) VALUES (%s,%s,%s,NOW())",
        (email, otp, expiry)
    )

    db.commit()

    send_otp_email(email, otp)

    return jsonify({"status": "success", "message": "OTP sent"}), 200

# ==============================
# VERIFY OTP
# ==============================
@app.route("/verify-otp", methods=["POST"])
def verify_otp():

    data = request.json
    email = data.get("email")
    otp = data.get("otp")

    db = get_db_connection()
    cursor = db.cursor(dictionary=True)

    cursor.execute("SELECT otp, expires_at FROM password_resets WHERE email=%s", (email,))
    record = cursor.fetchone()

    if not record:
        return jsonify({"status": "error", "message": "OTP not found"}), 400

    if datetime.now() > record["expires_at"]:
        return jsonify({"status": "error", "message": "OTP expired"}), 400

    if str(otp) != str(record["otp"]):
        return jsonify({"status": "error", "message": "Invalid OTP"}), 400

    return jsonify({"status": "success", "message": "OTP verified"}), 200

# ==============================
# RESET PASSWORD
# ==============================
@app.route("/reset-password", methods=["POST"])
def reset_password():

    data = request.json
    email = data.get("email")
    new_password = data.get("new_password")

    db = get_db_connection()
    cursor = db.cursor(dictionary=True)

    new_hash = generate_password_hash(new_password)

    cursor.execute("UPDATE users SET password_hash=%s WHERE email=%s", (new_hash, email))
    cursor.execute("DELETE FROM password_resets WHERE email=%s", (email,))

    db.commit()

    return jsonify({"status": "success", "message": "Password reset successful"}), 200


# ==============================
# IMAGE UPLOAD + AI ANALYSIS
# ==============================

@app.route("/upload", methods=["POST"])
def upload_image():

    try:

        image1 = request.files.get("image1")
        image2 = request.files.get("image2")
        image3 = request.files.get("image3")
        user_id = request.form.get("user_id")

        if not all([image1, image2, image3, user_id]):
            return jsonify({"status": "error", "message": "Three images required"}), 400

        images = [image1, image2, image3]
        detections = []
        roboflow_scores = []
        heatmaps = []

        for img in images:

            filename = f"{uuid.uuid4()}_{img.filename}"
            path = os.path.join(BASE_UPLOAD_FOLDER, filename)

            img.save(path)

            # ------------------------------
            # Roboflow detection
            # ------------------------------

            url = "https://serverless.roboflow.com/endo-tip-detection/2"
            params = {"api_key": "NoIwL2M0uYgrFt7uctp2"}

            with open(path, "rb") as f:
                response = requests.post(url, params=params, files={"file": f})

            result = response.json()
            predictions = result.get("predictions", [])

            confidence = float(predictions[0]["confidence"]) if predictions else 0.0
            roboflow_scores.append(confidence)

            # ------------------------------
            # CNN prediction
            # ------------------------------

            img_loaded = image.load_img(path, target_size=(224,224))
            img_array = image.img_to_array(img_loaded) / 255.0
            img_array = tf.expand_dims(img_array,0)

            cnn_pred = float(cnn_model.predict(img_array, verbose=0)[0][0])
            cnn_pred = np.clip(cnn_pred, 0, 1)

            print("Roboflow:", confidence)
            print("CNN:", cnn_pred)

            # combine both predictions
            # cnn_pred: 1.0 (safe), 0.0 (not safe)
            # roboflow confidence: 1.0 (defect found), 0.0 (no defect)
            roboflow_safe_score = 1.0 - confidence
            combined_score = (cnn_pred * 0.6) + (roboflow_safe_score * 0.4)
            detections.append(combined_score)

            # ------------------------------
            # Heatmap
            # ------------------------------

            base_model = cnn_model.get_layer("mobilenetv2_1.00_224")

            heatmap = generate_heatmap(
                base_model,
                img_array,
                "Conv_1"
            )

            heatmap_path = overlay_heatmap(path, heatmap)

            heatmaps.append(os.path.basename(heatmap_path))

        # ==============================
        # VERIFY IF IT IS AN ENDODONTIC FILE
        # ==============================

        # If Roboflow confidence is extremely low for all images
        # it likely means the uploaded image is NOT an endodontic file

        if sum(roboflow_scores)/3 < 0.35:
            return jsonify({
                "status": "error",
                "is_endo_file": False,
                "message": "Uploaded images do not appear to contain an endodontic file."
            }), 400

        # ------------------------------
        # Final AI scoring
        # ------------------------------

        angle1 = detections[0]
        angle2 = detections[1]
        angle3 = detections[2]

        # average structural integrity from 3 viewing angles
        structural_integrity = (
            angle1 +
            angle2 +
            angle3
        ) / 3 * 100

        structural_integrity = min(max(structural_integrity, 0), 100)
        def classify(score):
            if score < 0.4:
                return "Unsafe"

            elif score < 0.7:
                return "Medium Wear"

            else:
                return "Safe"


        segment_results = [
            {"name": "Angle 1 (0°–120°)", "status": classify(angle1)},
            {"name": "Angle 2 (120°–240°)", "status": classify(angle2)},
            {"name": "Angle 3 (240°–360°)", "status": classify(angle3)}
        ]

        fatigue_score = 100 - structural_integrity

        if fatigue_score > 50:
            prediction = "not_safe"
            recommendation = "High risk of file separation detected. Do not reuse. Discard immediately."

        elif fatigue_score > 30:
            prediction = "borderline"
            recommendation = "Moderate fatigue detected. Use with caution."

        else:
            prediction = "safe"
            recommendation = "File appears safe for reuse."


        return jsonify({
            "status": "success",
            "is_endo_file": True,
            "prediction": prediction,
            "recommendation": recommendation,
            "confidence": fatigue_score / 100,
            "fatigue_score": fatigue_score,
            "structural_integrity": structural_integrity,
            "segment_results": segment_results,
            "heatmaps": heatmaps
        }), 200


    except Exception as e:

        print("UPLOAD ERROR:", e, flush=True)

        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500


# ==============================
# RUN SERVER
# ==============================

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True, use_reloader=False)
from flask import Flask, render_template, request, jsonify
from models.classification import predict_report
from database import init_db, save_report, get_reports

app = Flask(__name__)


init_db()



@app.route("/")
@app.route("/index")
def home():
    return render_template("index.html")

@app.route("/new-report")
def new_report():
    return render_template("new-report.html")

@app.route("/summary")
def summary():
    return render_template("summary.html")

@app.route("/success")
def success():
    return render_template("success.html")

@app.route("/reports")
def reports():
    all_reports = get_reports()
    return render_template("reports.html", reports=all_reports)

@app.route("/dashboard")
def dashboard():
    return render_template("dashbord-reports.html")



@app.route("/predict", methods=["POST"])
def predict():
    data = request.json
    text = data.get("text", "")

    if text.strip() == "":
        return jsonify({"error": "empty text"}), 400

    label, authority = predict_report(text)
    return jsonify({"label": label, "authority": authority})



@app.route("/api/save-report", methods=["POST"])
def save_report_api():
    try:
        data = request.json

        report_id = save_report(
            description=data.get('description', ''),
            report_type=data.get('type', ''),
            authority=data.get('authority', ''),
            location=data.get('location', ''),
            date=data.get('date', ''),
            time=data.get('time', '')
        )

        return jsonify({
            "success": True,
            "report_id": report_id
        })

    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500


if __name__ == "__main__":
    app.run(debug=True)




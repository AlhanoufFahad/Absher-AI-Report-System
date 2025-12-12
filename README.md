# Absher Smart Report Classifier

## Project Context
This project was developed under the **Innovation and Development of Absher Services Track** as part of the **Absher–Tuwaiq Hackathon 2025**, organized in collaboration with the **Saudi Ministry of Interior**.  
The goal of the hackathon is to enhance and modernize digital services within the Absher platform through innovative, AI-powered solutions that improve efficiency, user experience, and security responsiveness.

---

## Overview
The **Absher Smart Report Classifier** is an AI-powered system designed to analyze security reports submitted by citizens and residents.  
The system automatically:

- Reads and processes the report text  
- Classifies the type of incident  
- Identifies the responsible authority (Police, Traffic, Civil Defense, etc.)  
- Supports image uploads and location input  
- Saves all reports into a local SQLite database  
- Generates a summary for the user before submission  

This MVP showcases how AI can accelerate response times, reduce load on call centers, and improve the accuracy of routing reports across security authorities.

---

## Repository Structure

This repository contains the project in **two formats**:

### Extracted Project Files (Recommended)
Fully extracted files and folders uploaded directly to the repository for easy navigation:

- `/api`
- `/models`
- `/templates`
- `/static`
- `/database`
- `app.py`
- `requirements.txt`
- `reports.db`
- Additional supporting modules

### Original ZIP File
The repository also includes the original archive:

## Absher-Project_Last_Update_Codes.zip

This ZIP contains the complete project before extraction and is preserved for backup and portability.

---

## Features

- AI-driven classification of security reports  
- Predicts:
  - Report Type  
  - Responsible Authority  
- Location input (prototype)  
- Image upload support  
- SQLite database storing:
  - Report ID  
  - Description  
  - Type  
  - Authority  
  - Date & time  
  - Location  
  - Image path  
- Clean and responsive UI using HTML, CSS, JS  
- Flask backend for handling routes, predictions, and database operations  
- Fully functioning MVP demonstrating end-to-end flow  

---
## Install dependencies
```
pip install -r requirements.txt
```

## Run the Flask app
```
python app.py
```

## Database Details
- The project uses a local SQLite database:

```reports.db```

Stored fields include:
- Report ID
- Description
- Predicted Type
- Predicted Authority
- Date and Time
- Location
- Image Path

## Notes

- The project files are provided in two formats: extracted directories and a ZIP archive.
- Developers may work directly with the extracted version or download the ZIP as needed.
- This project is part of the Absher–Tuwaiq Hackathon 2025 initiative under the Ministry of Interior.

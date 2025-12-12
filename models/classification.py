import pickle
import os
import numpy as np

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

LABEL_MODEL = os.path.join(BASE_DIR, "label_model.pkl")
AUTH_MODEL = os.path.join(BASE_DIR, "authority_model.pkl")
VECTORIZER = os.path.join(BASE_DIR, "vectorizer.pkl")

def load_models():
    """تحميل جميع النماذج"""
    try:
        with open(LABEL_MODEL, "rb") as f:
            label_model = pickle.load(f)
        
        with open(AUTH_MODEL, "rb") as f:
            authority_model = pickle.load(f)
        
        with open(VECTORIZER, "rb") as f:
            vectorizer = pickle.load(f)
        
        print("تم تحميل النماذج بنجاح!")
        return label_model, authority_model, vectorizer
    except Exception as e:
        print(f" خطأ في تحميل النماذج: {e}")
        return None, None, None

label_model, authority_model, vectorizer = load_models()

def predict_report(text):
    """
    التنبؤ بنوع البلاغ والجهة المختصة
    """
    try:
        text = text.strip().lower()
        
        if len(text) < 3:
            return "بلاغ عام", "بلدية الرياض"
        
        X = vectorizer.transform([text])

        label_pred = label_model.predict(X)
        label = str(label_pred[0]) if hasattr(label_pred, '__len__') else str(label_pred)
        
        auth_pred = authority_model.predict(X)
        authority = str(auth_pred[0]) if hasattr(auth_pred, '__len__') else str(auth_pred)
        
        print(f" النص: {text[:50]}...")
        print(f" النوع المتوقع: {label}")
        print(f" الجهة المتوقعة: {authority}")
        
        return label, authority
        
    except Exception as e:
        print(f" خطأ في التنبؤ: {e}")
        return "بلاغ عام", "بلدية الرياض"

def test_prediction():
    """اختبار دالة التنبؤ"""
    test_texts = [
        "حادث سيارتين في الشارع الرئيسي",
        "حريق في مبنى سكني",
        "انقطاع المياه عن الحي",
        "مشكلة في الكهرباء",
        "قمامة متراكمة في الشارع"
    ]
    
    for text in test_texts:
        label, authority = predict_report(text)
        print(f"النص: {text}")
        print(f"النوع: {label}")
        print(f"الجهة: {authority}")
        print("-" * 40)

if __name__ == "__main__":
    test_prediction()
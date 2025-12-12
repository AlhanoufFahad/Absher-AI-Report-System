import re

def clean_text(text):
    """تنظيف نص البلاغ قبل الإرسال للنموذج"""
    text = text.lower()
    text = re.sub(r'[^\w\s]', '', text)
    text = re.sub(r'\s+', ' ', text).strip()
    return text


def normalize_text(text):
    text = text.lower()
    
    replacements = {
        "مويا": "مياه",
        "موية": "مياه",
        "تسريب": "تسرب",
        "تهريب": "تهريب",
        "حريقه": "حريق",
        "حرايق": "حريق",
        "سطو": "سرقة",
        "سرق": "سرقة",
        "مسروق": "سرقة",
        "ضايع": "فقدان",
        "ضاع": "فقدان",
        "اختفى": "فقدان",
        "ماس": "ماس كهربائي",
        "كهرب": "ماس كهربائي",
    }
    for word, replacement in replacements.items():
        text = text.replace(word, replacement)

    return text

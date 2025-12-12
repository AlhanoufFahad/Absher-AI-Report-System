import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.model_selection import train_test_split
from sklearn.naive_bayes import MultinomialNB
import pickle

df = pd.read_csv("reports_10000_dataset_1.csv")

X = df['report'].astype(str)
y_label = df['label']
y_auth = df['authority']

vectorizer = TfidfVectorizer(max_features=5000)
X_vec = vectorizer.fit_transform(X)

model_label = MultinomialNB()
model_label.fit(X_vec, y_label)

model_auth = MultinomialNB()
model_auth.fit(X_vec, y_auth)

with open("label_model.pkl", "wb") as f:
    pickle.dump(model_label, f)

with open("authority_model.pkl", "wb") as f:
    pickle.dump(model_auth, f)

with open("vectorizer.pkl", "wb") as f:
    pickle.dump(vectorizer, f)

print(" تم تدريب النموذج وتخزين الملفات بنجاح")

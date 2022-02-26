import uvicorn
import sklearn
import pickle
import joblib
import numpy as np 
import pandas as pd
from preprocessing import cleaning
from fastapi import FastAPI, Request, File, Form
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates # web template engine for python.

tfidf_vec = open('models/tfidf_vectorizer.pkl', 'rb')
tfidf_vec = joblib.load(tfidf_vec)

model = open('models/logreg_tweet_classifier.pkl', 'rb')
model = joblib.load(model)

# init app
app = FastAPI() 

app.mount("/static", StaticFiles(directory="static"), name="static") #we are mounting static

templates = Jinja2Templates(directory="templates") #as a template we will use templates folder

#ML aspect
@app.get("/")
async def predict():
    return "weilcome guys"

# ML Aspect
@app.get("/predict/{tweet}")
async def predict(tweet: str):

    #tweet = request.form['tweet']
    
    cleaned_text = pd.Series(tweet).apply(cleaning)
    vectorized_text = tfidf_vec.transform([cleaned_text]).toarray()
    prediction = model.predict(vectorized_text)
    prob = model.predict_proba(vectorized_text)

    return {"original_text":tweet, "prediction":prediction[0], "Prob":np.max(np.round(prob,3))}


@app.get("/main", response_class=HTMLResponse) #http://localhost:8009/main with this line, you can see this subject
def home_func(request: Request):
    return templates.TemplateResponse("item.html", {"request": request, "airline": ""})

@app.get("/main/{air_line}", response_class=HTMLResponse) # http://localhost:8009/main/American Airlines 
def home(request: Request, air_line: str):
    return templates.TemplateResponse("item.html", {"request": request, "airline": air_line})

# POST end-point
@app.post("/get_tweet")
async def handle_tweet(request: Request, tweet: str = Form(...)):
    #cleaned_text = pd.Series(tweet).apply(cleaning)
    vectorized_text = tfidf_vec.transform([tweet]).toarray()
    prediction = model.predict(vectorized_text)
    prob = model.predict_proba(vectorized_text)

    return templates.TemplateResponse("item2.html", 
            {"request": request, "airline":"", "original_text":tweet, "prediction":prediction[0], 
             "Prob":np.max(np.round(prob,3))})





if __name__=='__main__':
    uvicorn.run(app, host='0.0.0.0', port=8009) #this one usually 8000 but at this time




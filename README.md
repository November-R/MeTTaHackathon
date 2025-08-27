# Movie Recommendation System

A small web app that suggests movies to users based on their preferences, watch history, and similar users’ tastes. Users can also rate movies and update their preferences.

---

## Features

* Select a user and see their **movie recommendations**

  * By genre
  * By director
  * Based on similar users
* **Update your movie preferences** (like genres you enjoy)
* **Rate movies** you’ve watched
* **View watch history** for each user
* Lightweight frontend feedback (thank-you messages) without hitting the backend every time

---

## Files in the Project

* `index.html` – Main webpage with user interface
* `style.css` – Styling for the webpage
* `script.js` – Handles frontend logic, button clicks, and displaying lists
* `app.py` – Flask backend that handles API requests and queries
* `knowledgeGraph.metta` – Knowledge base with movies, users, genres, directors, and rules
* `metta_helpers.py` (or included in `app.py`) – Python functions to load the Metta knowledge base and execute queries

---

## How to Run

1. Make sure Python and Flask are installed.
2. Install `hyperon` for Metta support:

```bash
pip install hyperon
```

3. Run the Flask server:

```bash
python app.py
```

4. Open your browser and go to:

```
http://127.0.0.1:5000/
```

5. Select a user, explore recommendations, update preferences, and rate movies.

---

## How it Works

* **Frontend (HTML + CSS + JS)**

  * Lets users select themselves, see recommendations, and interact with the app
  * Displays lists dynamically and shows thank-you messages for actions

* **Backend (Python + Flask + Metta)**

  * Stores facts about movies, users, preferences, and watched movies
  * Queries the knowledge base to generate recommendations
  * Returns data as JSON to the frontend

* **Metta Knowledge Base**

  * Contains movies with genres and directors
  * Stores user preferences, watch history, and simple rules for recommendations

---

## Notes

* This is a hackathon project – it’s functional but not fully optimized
* Frontend feedback is lightweight to make the interface feel fast
* The Metta rules are simple and rule-based, not machine learning


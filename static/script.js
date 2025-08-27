
// our variables
const userSelect = document.getElementById("userSelect");
const recommendationList = document.getElementById("recommendationList");
const genreInput = document.getElementById("genreInput");
const updatePrefBtn = document.getElementById("updatePrefBtn");
const movieNameInput = document.getElementById("movieNameInput");
const ratingSelect = document.getElementById("ratingSelect");
const rateMovieBtn = document.getElementById("rateMovieBtn");
const viewHistoryBtn = document.getElementById("viewHistoryBtn");
const historyList = document.getElementById("historyList");
const preferencesList = document.getElementById("preferencesList");

//buttons variables
const byGenreBtn = document.getElementById("byGenreBtn");
const byDirectorBtn = document.getElementById("byDirectorBtn");
const byCollabBtn = document.getElementById("byCollabBtn");

let currentUser = "";

//Render list
function renderList(listElement, items) {
    listElement.innerHTML = "";
    if (!items || items.length === 0) {
        listElement.innerHTML = "<li>No data available.</li>";
        return;
    }
    items.forEach(item => {
        const li = document.createElement("li");
        li.textContent = item.title ? `${item.title}${item.reason ? " - " + item.reason : ""}` : item;
        listElement.appendChild(li);
    });
}

//Recommendations function
async function fetchRecommendations(type) {
    if (!currentUser) return;

    let endpoint = "";
    switch (type) {
        case "genre":
             endpoint = `/recommend/${currentUser}`;
        break;
        case "director":
             endpoint = `/recommendByDirector/${currentUser}`;
        break;
        case "collab":
             endpoint = `/recommendByCollaboration/${currentUser}`;
        break;
    }

    try {
        const res = await fetch(endpoint);
        const data = await res.json();
        renderList(recommendationList, data.recommendations);
    } catch (err) {
        console.error(err);
    }
}

// User Preferences Function
async function fetchPreferences() {
    if (!currentUser) return;

    try {
        const res = await fetch(`/getUserPreferences/${currentUser}`);
        const data = await res.json();
        renderList(preferencesList, data.recommendations.map(r => r.title || r));
    } catch (err) {
        console.error(err);
    }
}

// Watch History Function
async function fetchHistory() {
    if (!currentUser) return;
    try {
        const res = await fetch(`/getWatchHistory/${currentUser}`);
        const data = await res.json();
        renderList(historyList, data.recommendations.map(r => r.title || r));
    } catch (err) {
        console.error(err);
    }
}

//  Update Preference function
updatePrefBtn.addEventListener("click", () => {
    const genre = genreInput.value.trim();
    if (!currentUser || !genre) return alert("Select user & enter genre");

    //CSS to Display thank-you message
    const feedbackMessage = document.createElement("p");
    feedbackMessage.textContent = `Thank you! Noted your preference for "${genre}". We'll update your preferences soon.`;
    feedbackMessage.style.color = "#08b6a4";
    feedbackMessage.style.fontWeight = "bold";
    feedbackMessage.style.marginTop = "10px";

    const prefContainer = updatePrefBtn.parentElement;
    prefContainer.appendChild(feedbackMessage);

    // Clear input field
    genreInput.value = "";

});


//Rate Movie Function
rateMovieBtn.addEventListener("click", () => {
    const movie = movieNameInput.value.trim();
    const rating = ratingSelect.value;

    if (!currentUser || !movie || !rating) {
        return alert("Complete all fields before submitting.");
    }

    //thank-you message
    const feedbackMessage = document.createElement("p");
    feedbackMessage.textContent = `Thank you! We've received your feedback for "${movie}" with a rating of ${rating}.`;
    feedbackMessage.style.color = "#08b6a4";
    feedbackMessage.style.fontWeight = "bold";
    feedbackMessage.style.marginTop = "10px";

    const ratingContainer = rateMovieBtn.parentElement;
    ratingContainer.appendChild(feedbackMessage);

    movieNameInput.value = "";
    ratingSelect.value = "";

});


//Button Events 
userSelect.addEventListener("change", e => {
    currentUser = e.target.value;
    fetchPreferences();
    fetchHistory();
    recommendationList.innerHTML = "";
});

byGenreBtn.addEventListener("click", () => fetchRecommendations("genre"));
byDirectorBtn.addEventListener("click", () => fetchRecommendations("director"));
byCollabBtn.addEventListener("click", () => fetchRecommendations("collab"));

viewHistoryBtn.addEventListener("click", fetchHistory);

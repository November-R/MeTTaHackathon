
// DOM Elements
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

const byGenreBtn = document.getElementById("byGenreBtn");
const byDirectorBtn = document.getElementById("byDirectorBtn");
const byCollabBtn = document.getElementById("byCollabBtn");

let currentUser = "";

// Helper: render list
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

// --- Fetch Recommendations ---
async function fetchRecommendations(type) {
    if (!currentUser) return;

    let endpoint = "";
    switch (type) {
        case "genre": endpoint = `/recommend/${currentUser}`; break;
        case "director": endpoint = `/recommendByDirector/${currentUser}`; break;
        case "collab": endpoint = `/recommendByCollaboration/${currentUser}`; break;
    }

    try {
        const res = await fetch(endpoint);
        const data = await res.json();
        renderList(recommendationList, data.recommendations);
    } catch (err) {
        console.error(err);
    }
}

// --- Fetch User Preferences ---
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

// --- Fetch Watch History ---
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

// --- Update Preference ---
updatePrefBtn.addEventListener("click", async () => {
    const genre = genreInput.value.trim();
    if (!currentUser || !genre) return alert("Select user & enter genre");

    try {
        await fetch("/query", {
            method: "POST",
            headers: {"Content-Type":"application/json"},
            body: JSON.stringify({query: `!(likes ${currentUser} ${genre})`})
        });
        genreInput.value = "";
        fetchPreferences();
        fetchRecommendations("genre");
    } catch(err){console.error(err);}
});

// --- Rate Movie (frontend-only, lightweight) ---
rateMovieBtn.addEventListener("click", () => {
    const movie = movieNameInput.value.trim();
    const rating = ratingSelect.value;

    if (!currentUser || !movie || !rating) {
        return alert("Complete all fields before submitting.");
    }

    // Display thank-you message
    const feedbackMessage = document.createElement("p");
    feedbackMessage.textContent = `Thank you! We've received your feedback for "${movie}" with a rating of ${rating}.`;
    feedbackMessage.style.color = "#08b6a4";
    feedbackMessage.style.fontWeight = "bold";
    feedbackMessage.style.marginTop = "10px";

    // Append message below the rating section
    const ratingContainer = rateMovieBtn.parentElement;
    ratingContainer.appendChild(feedbackMessage);

    // Clear input fields
    movieNameInput.value = "";
    ratingSelect.value = "";

    // Automatically remove message after 5 seconds
    /*setTimeout(() => {
        feedbackMessage.remove();
    }, 5000);*/
});


// --- Button Events ---
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

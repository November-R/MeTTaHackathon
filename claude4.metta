; Movies and their attribute representation
(movie Movie1 Title "Freaky Friday" Genre Comedy Director "Mark Waters")
(movie Movie2 Title "The Addams" Genre Comedy Director "Barry Sonnenfeld")
(movie Movie3 Title "Happy Gilmore" Genre Comedy Director "Dennis Dugan")
(movie Movie4 Title "The Matrix" Genre SciFi Director "Lana Wachowski")
(movie Movie5 Title "Dune" Genre SciFi Director "Denis Villeneuve")
(movie Movie6 Title "The Electric State" Genre SciFi Director "Anthony Russo")
(movie Movie7 Title "Avengers" Genre Action Director "Anthony Russo")
(movie Movie8 Title "Captain America" Genre Action Director "Anthony Russo")
(movie Movie9 Title "White House Down" Genre Action Director "Roland Emmerich")
(movie Movie10 Title "Desperate Housewives" Genre Drama Director "Marc Cherry")
(movie Movie11 Title "Challengers" Genre Drama Director "Luca Guadagnino")
(movie Movie12 Title "Clueless" Genre Drama Director "Amy Heckerling")
(movie Movie13 Title "It" Genre Horror Director "Andres Muschietti")
(movie Movie14 Title "Us" Genre Horror Director "Jordan Peele")
(movie Movie15 Title "Get Out" Genre Horror Director "Jordan Peele")

; User Preferences
(user user1 Jane Preferences (Action SciFi) Watched (Movie7 Movie6))
(user user2 Ophelia Preferences (Horror Comedy) Watched (Movie13 Movie2))
(user user3 Angela Preferences (Action Drama) Watched (Movie7 Movie10))

; Simple rule-based approach using facts instead of complex matching
(likes user1 Action)
(likes user1 SciFi)
(likes user2 Horror) 
(likes user2 Comedy)
(likes user3 Action)
(likes user3 Drama)

(watched user1 Movie7)
(watched user1 Movie6)
(watched user2 Movie13)
(watched user2 Movie2)
(watched user3 Movie7)
(watched user3 Movie10)

; Director preferences based on watched movies
(likesDirector user1 "Anthony Russo")  ; From watching Avengers and Electric State
(likesDirector user2 "Andres Muschietti")  ; From watching It
(likesDirector user2 "Barry Sonnenfeld")  ; From watching The Addams
(likesDirector user3 "Anthony Russo")  ; From watching Avengers
(likesDirector user3 "Marc Cherry")  ; From watching Desperate Housewives

; Working approach - using filter logic (THIS ONE WORKS!)
(= (recommend $userId)
    (collapse
        (match &self (movie $movieId Title $title Genre $genre Director $director)
            (match &self (likes $userId $genre)
                ; Create a conditional check
                (let $isWatched (collapse (match &self (watched $userId $movieId) True))
                    (if (== $isWatched (True))
                        () ; Skip if watched
                        (str $title " - Recommended because you like " $genre " movies") ; Recommend if not watched
                    )
                )
            )
        )
    )
)

; Director-based recommendation function
(= (recommendByDirector $userId)
    (collapse
        (match &self (movie $movieId Title $title Genre $genre Director $director)
            (match &self (likesDirector $userId $director)
                ; Create a conditional check
                (let $isWatched (collapse (match &self (watched $userId $movieId) True))
                    (if (== $isWatched (True))
                        () ; Skip if watched
                        (str $title " - Recommended because you liked other movies by " $director) ; Recommend if not watched
                    )
                )
            )
        )
    )
)

; ADAPTIVE LEARNING FUNCTIONS

; Main function to watch a movie and learn preferences
(= (watchMovie $userId $movieId)
    (match &self (movie $movieId Title $title Genre $genre Director $director)
        ; First, add the movie to watched list
        (let $addWatched (add-atom &self (watched $userId $movieId))
            ; Check if user already likes this genre
            (let $alreadyLikes (collapse (match &self (likes $userId $genre) True))
                (if (== $alreadyLikes (True))
                    ; User already likes this genre
                    (str "Watched " $title ". You already like " $genre " movies.")
                    ; New genre discovered! Add it to preferences
                    (let $addGenre (add-atom &self (likes $userId $genre))
                        ; Also add director preference if it's a new genre
                        (let $addDirector (add-atom &self (likesDirector $userId $director))
                            (str "Watched " $title ". Discovered you like " $genre " movies and director " $director "!")
                        )
                    )
                )
            )
        )
    )
)

; Function to check if a user already likes a genre
(= (hasGenrePreference $userId $genre)
    (let $likes (collapse (match &self (likes $userId $genre) True))
        (if (== $likes (True))
            "Yes"
            "No"
        )
    )
)

; Function to get all current preferences for a user
(= (getUserPreferences $userId)
    (collapse
        (match &self (likes $userId $genre)
            (str $userId " likes " $genre)
        )
    )
)

; Function to get watch history for a user
(= (getWatchHistory $userId)
    (collapse
        (match &self (watched $userId $movieId)
            (match &self (movie $movieId Title $title Genre $genre Director $director)
                (str $userId " watched: " $title " (" $genre ")")
            )
        )
    )
)

; Function to manually add a genre preference (for testing)
(= (addGenrePreference $userId $genre)
    (let $alreadyLikes (collapse (match &self (likes $userId $genre) True))
        (if (== $alreadyLikes (True))
            (str $userId " already likes " $genre)
            (let $addGenre (add-atom &self (likes $userId $genre))
                (str "Added " $genre " preference for " $userId)
            )
        )
    )
)

; Enhanced recommendation that shows learning progress
(= (recommendWithLearning $userId)
    (collapse
        (match &self (movie $movieId Title $title Genre $genre Director $director)
            (match &self (likes $userId $genre)
                (let $isWatched (collapse (match &self (watched $userId $movieId) True))
                    (if (== $isWatched (True))
                        ()
                        (str $title " - " $genre " (you learned to like this genre!)")
                    )
                )
            )
        )
    )
)

; Test current system
(recommend user1)
(recommendByDirector user1)

; Test learning functions
(getUserPreferences user1)
!(getWatchHistory user1)

; Example: Let user1 watch a Horror movie (new genre)
; This would be: !(watchMovie user1 Movie13)
; Result: User1 would learn to like Horror movies
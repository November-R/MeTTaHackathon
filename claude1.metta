
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

; Working approach - using filter logic (THIS ONE WORKS!)
(= (recommend $userId)
    (collapse
        (match &self (movie $movieId Title $title Genre $genre Director $director)
            (match &self (likes $userId $genre)
                ; Create a conditional check
                (let $isWatched (collapse (match &self (watched $userId $movieId) True))
                    (if (== $isWatched (True))
                        "already watched" ; Skip if watched
                        (str $title " - Recommended because you like " $genre " movies") ; Recommend if not watched
                    )
                )
            )
        )
    )
)

; Clean version - remove empty results
(= (recommendClean $userId)
    (filter (recommend $userId) (λ $x (not (== $x ()))))
)

; Alternative approach using same logic as working recommend
(= (recommendSimple $userId)
    (collapse
        (match &self (movie $movieId Title $title Genre $genre Director $director)
            (match &self (likes $userId $genre)
                (let $isWatched (collapse (match &self (watched $userId $movieId) True))
                    (if (== $isWatched (True))
                        () 
                        (str $title " - Recommended")
                    )
                )
            )
        )
    )
)

; Method 3: Most basic approach - shows all preferences (for testing)
(= (recommendBasic $userId)
    (collapse
        (match &self (likes $userId $genre)
            (match &self (movie $movieId Title $title Genre $genre Director $director)
                (str $title " - " $genre " recommendation")
            )
        )
    )
)

; Test all approaches
!(recommend user1)
(recommendSimple user1)
(recommendBasic user1)

; Manual check - movies user1 likes but hasn't watched
; User1 likes Action and SciFi, watched Movie7 (Avengers) and Movie6 (Electric State)

; Should recommend: Movie4 (Matrix-SciFi), Movie5 (Dune-SciFi), Movie8 (Captain America-Action), Movie9 (White House Down-Action)
(match &self (movie Movie4 Title "The Matrix" Genre SciFi Director $director)
    (match &self (likes user1 SciFi) "Should recommend The Matrix"))

(match &self (movie Movie8 Title "Captain America" Genre Action Director $director)  
    (match &self (likes user1 Action) "Should recommend Captain America"))

; Test the watched check
(match &self (watched user1 Movie4) "Movie4 is watched")
(match &self (watched user1 Movie7) "Movie7 is watched")
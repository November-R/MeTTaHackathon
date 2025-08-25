
;movies and their attribute representation
;movieId and userId act as our primary key
;comedies
(movie Movie1 Title "Freaky Friday" Genre Comedy Director "Mark Waters")
(movie Movie2 Title "The Addams" Genre Comedy Director "Barry Sonnenfeld")
(movie Movie3 Title "Happy Gilmore" Genre Comedy Director "Dennis Dugan")

;sci-fi
(movie Movie4 Title "The Matrix" Genre SciFi Director "Lana Wachowski")
(movie Movie5 Title "Dune" Genre SciFi Director "Denis Villeneuve")
(movie Movie6 Title "The Electric State" Genre SciFi Director "Anthony Russo")

;action
(movie Movie7 Title "Avengers" Genre Action Director "Anthony Russo")
(movie Movie8 Title "Captain America" Genre Action Director "Anthony Russo")
(movie Movie9 Title "White House Down" Genre Action Director "Roland Emmerich")

;Drama
(movie Movie10 Title "Desperate Housewives" Genre Drama Director "Marc Cherry")
(movie Movie11 Title "Challengers" Genre Drama Director "Luca Guadagnino")
(movie Movie12 Title "Clueless" Genre Drama Director "Amy Heckerling")

;horror
(movie Movie13 Title "It" Genre Horror Director "Andres Muschietti")
(movie Movie14 Title "Us" Genre Drama Director "Jordan Peele")
(movie Movie15 Title "Get Out" Genre Drama Director "Jordan Peele")

;User Preference
(user user1 Jane Preferences (Action SciFi) Watched (Movie7 Movie6))
(user user2 Ophelia Preferences (Horror Comedy) Watched (Movie13 Movie2))
(user user3 Angela Preferences (Action Drama ) Watched (Movie7 Movie10))

;Define Relationship
(genre-similarity Action SciFi High)
(genre-similarity Horror Drama low)
(genre-similarity Drama Comedy Medium)
(genre-similarity comedies Horror low)
(genre-similarity SciFi Horror  High)

(director-preference "Anthony Russo" Jane High)
;add for ophelia  nad jane too

(actor "Zendaya" Movie11)
(actor-preference "Zendaya" Jane High)

;functions
;get recommendation function
;retrives movies from the dataset
(= (getMovies $movieGenre)
    (match &self (movie $MovieId Title $movieTitle Genre $movieGenre Director $directorName) ($MovieId $movieTitle))
)
(getMovies Action)

;retrives the movies the user likes
(= (getUserPreference $movieWatched)
    (match &self (user $userId $userName Preferences $userPreference Watched $movieWatched) (superpose $userPreference))
)
(getUserPreference user3)


;(= (getRecommendation $userId)
    ;(match &self (user $userId $userName Preferences $userPreference Watched $movieWatched) $userPreference)
    ;(match &self (movie $MovieId Title $movieTitle Genre $movieGenre Director $directorName) $movieGenre $movieTitle)
    ;(if (== $userPreference $movieGenre)
        ;$movieTitle
        ;()
    ;)

;)


;(= (getRecommendation $userId)
    ;(let*
        ;(  
            ;($userMovie (getUserPreference $movieWatched))
            ;($databaseMovie (getMovies $movieId))
            ;($commonMovie (intersection-atom $userMovie $databaseMovie))
        ;)
        ;(if (== $commonMovie ())
            ;$movieGenre
            ;()
        ;)
    ;)
;)

;!(getRecommendation user1)




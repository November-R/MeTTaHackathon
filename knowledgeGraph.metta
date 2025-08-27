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


(= (recommend $userId)(collapse(match &self (movie $movieId Title $title Genre $genre Director $director)(match &self (likes $userId $genre)(let $isWatched (collapse (match &self (watched $userId $movieId) True))(if (== $isWatched (True))() ($title " - Recommended because you like " $genre " movies") ))))))

(= (recommendByDirector $userId)(collapse(match &self (movie $movieId Title $title Genre $genre Director $director)(match &self (likesDirector $userId $director)(let $isWatched (collapse (match &self (watched $userId $movieId) True))(if (== $isWatched (True))() ($title " - Recommended because you liked other movies directed by " $director) ))))))

(= (recommendByCollaboration $userId)(collapse(match &self (likes $otherUser $genre)(if (== $userId $otherUser)()(match &self (likes $userId $genre)(match &self (watched $otherUser $movieId)(let $targetWatched (collapse (match &self (watched $userId $movieId) True))(if (== $targetWatched (True))()(match &self (movie $movieId Title $title Genre $movieGenre Director $director)($title " - Similar user (" $otherUser ") who likes " $genre " also watched this movie and loved it!"))))))))))




% Knowledge Base

mood(happy).
mood(sad).
mood(stressed).
mood(bored).
mood(tired).
mood(excited).
mood(lonely).
mood(curious).

similar_mood(happy, excited).
similar_mood(sad, stressed).
similar_mood(sad, lonely).
similar_mood(bored, tired).
similar_mood(curious, excited).

energy(low).
energy(medium).
energy(high).

energy_fallback(low, medium).
energy_fallback(medium, high).
energy_fallback(medium, low).
energy_fallback(high, medium).

fav_genre(comedy).
fav_genre(crime).
fav_genre(romance).
fav_genre(action).
fav_genre(horror).
fav_genre(drama).
fav_genre(scifi).
fav_genre(documentary).
fav_genre(fantasy).
fav_genre(western).
fav_genre(anime).

complement_genre(scifi, action).
complement_genre(scifi, fantasy).
complement_genre(comedy, romance).
complement_genre(horror, drama).
complement_genre(horror, action).

time_available(0.5).
time_available(1).
time_available(1.5).
time_available(2).
time_available(2.5).
time_available(3).
time_available(3.5).
time_available(4).

% Ratings

rating(modern_family, 8.5).
rating(brokeback_mountain, 7.7).
rating(interstellar, 8.7).
rating(friends, 8.9).
rating(spirited_away, 8.6).
rating(zombieland, 7.5).
rating(mandalorian, 8.6).
rating(the_irishman, 7.8).
rating(pulp_fiction, 8.8).
rating(hereditary, 7.3).
rating(chernobyl, 9.3).
rating(knivesout, 7.9).
rating(clarksons_farm, 9.0).
rating(attack_on_titan, 9.1).
rating(titanic, 7.9).
rating('2001_a_space_odyssey', 8.3).

% Films and Shows

film_or_show(modern_family, bored, [low, medium, high], comedy, 0.5).
film_or_show(brokeback_mountain, sad, medium, [western, romance], 2.5).
film_or_show(interstellar, excited, high, [action, scifi, fantasy], 3).
film_or_show(friends, tired, [low, medium], [comedy, romance], 0.5).
film_or_show(spirited_away, stressed, low, [fantasy, anime], 2).
film_or_show(zombieland, lonely, [medium, high], [action, scifi, comedy], 1.5).
film_or_show(mandalorian, happy, [medium, high], [action, scifi], 1).
film_or_show(the_irishman, stressed, low, drama, 3.5).
film_or_show(pulp_fiction, bored, [low, medium, high], [drama, comedy, action], 2.5).
film_or_show(hereditary, excited, high, horror, 2).
film_or_show(chernobyl, lonely, [low, medium], drama, 1).
film_or_show(knivesout, curious, low, crime, 2.5).
film_or_show(clarksons_farm, happy, low, documentary, 1).
film_or_show(attack_on_titan, excited, high, [anime, action], 1).
film_or_show(titanic, sad, low, [romance, drama], 3.5).
film_or_show('2001_a_space_odyssey', curious, medium, scifi, 2.5).
film_or_show(the_office, bored, [low, medium], comedy, 0.5).
film_or_show(the_notebook, sad, low, romance, 2.5).
film_or_show(se7en, curious, [medium, high], [crime, drama], 2).
film_or_show(get_out, curious, medium, [horror, crime], 2).
film_or_show(dune, excited, high, [scifi, fantasy], 2.5).
film_or_show(the_lord_of_the_rings, curious, [medium, high], fantasy, 3.5).


% Rules

mood_match(Mood1, Mood2) :-
    Mood1 = Mood2.

mood_match(Mood1, Mood2) :-
    similar_mood(Mood1, Mood2).

mood_match(Mood1, Mood2) :-
    similar_mood(Mood2, Mood1).

genre_match(Genre1, Genre2) :-
    Genre1 = Genre2.

genre_match(Genre1, Genre2) :-
    complement_genre(Genre1, Genre2).

genre_match(Genre1, Genre2) :-
    complement_genre(Genre2, Genre1).

recommend(UserMood, UserEnergy, UserFavGenre, UserTime, Rating-FilmOrShow) :-
    film_or_show(FilmOrShow, Mood, Energy, FavGenre, Time),
    rating(FilmOrShow, Rating),

    (is_list(Mood) -> member(M, Mood) ; M = Mood),
    mood_match(UserMood, M),

    (is_list(Energy) -> member(UserEnergy, Energy) ; Energy = UserEnergy),

    (is_list(FavGenre) -> member(G, FavGenre) ; G = FavGenre), 
    genre_match(UserFavGenre, G),

    UserTime >= Time.

recommend_fallback(Mood, Energy, Genre, Time, Recommendations) :-
    findall(Rating-Film, recommend(Mood, Energy, Genre, Time, Rating-Film),
    Matches),
    Matches \= [],
    Recommendations = Matches,
    !.

recommend_fallback(Mood, Energy, Genre, Time, Recommendations) :-
    energy_fallback(Energy, Fallback),
    findall(Rating-Film, recommend(Mood, Fallback, Genre, Time, Rating-Film),
    Matches),
    Matches \= [],
    Recommendations = Matches.

start :-
    write("What is your mood right now? "), nl,
    write("Options: happy, sad, excited, stressed, bored, lonely, tired"), nl,
    read(Mood),

    write("What is your energy level right now? "), nl,
    write("Options: low, medium or high"), nl,
    read(Energy),

    write("What is your favourite genre of films and TV? "), nl,
    write("Options: comedy, romance, action, horror, drama,"), nl,
    write("scifi, documentary, fantasy, western, anime"), nl,
    read(FavGenre),

    write("How long do you have? (in hours)"), nl,
    write("Options: 0.5, 1, 1.5, 2, 2.5, 3, 3.5 or 4"), nl,
    read(Time),

recommend_fallback(
    Mood, Energy, FavGenre, Time, Recommendations),
(
    Recommendations = [] ->
        write("No recommendations. Sorry! :(")
    ;
        sort(Recommendations, Sorted),
        reverse(Sorted, Ranked), nl, 
        write("Recommendation/s: "), nl,
        show_list(Ranked)
).
    
show_list([]).
show_list([Rating-FilmOrShow|T]) :-
    write("You could watch "),
    write(FilmOrShow),
    write(" ("),
    write(Rating),
    write(") "), nl,
    show_list(T).





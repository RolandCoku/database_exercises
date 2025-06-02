/*
 1. From the following table, write a SQL query to find the name and year of the movies.
    Return movie title, movie release year.
 */

SELECT MOV_TITLE, MOV_YEAR
FROM MOVIE;

/*
 2. From the following table, write a SQL query to find when the movie 'American Beauty' released.
    Return movie release year
 */

SELECT MOV_YEAR
FROM MOVIE
WHERE MOV_TITLE LIKE 'American Beauty';

/*
 3. From the following table, write a SQL query to find the movie that was released in 1999.
    Return movie title.
 */

SELECT MOV_TITLE
FROM MOVIE
WHERE MOV_YEAR = 1999;

/*
 4. From the following table, write a SQL query to find those movies, which were released before 1998.
    Return movie title.
 */

SELECT MOV_TITLE
FROM MOVIE
WHERE MOV_YEAR < 1998;

/*
 5. From the following tables, write a SQL query to find the name of all reviewers and movies together in a single list.
 */

SELECT MOV_TITLE
FROM MOVIE
UNION
SELECT REV_NAME
FROM REVIEWER;

/*
 6. From the following table, write a SQL query to find all reviewers who have rated seven or more stars to their rating.
    Return reviewer name.
 */

SELECT REV.REV_NAME
FROM REVIEWER REV
JOIN RATING R ON R.REV_ID = REV.REV_ID
WHERE R.REV_STARS >= 7;

/*
 7. From the following tables, write a SQL query to find the movies without any rating.
    Return movie title.
 */

SELECT MOV.MOV_TITLE
FROM MOVIE MOV
WHERE MOV.MOV_ID NOT IN (
    SELECT R.MOV_ID
    FROM RATING R
    );

/*
 8. From the following table, write a SQL query to find the movies with ID 905 or 907 or 917.
    Return movie title.
 */

SELECT MOV_TITLE
FROM MOVIE
WHERE MOV_ID IN (905, 907, 917);

/*
 9. From the following table, write a SQL query to find the movie titles that contain the word 'Boogie Nights'. Sort the result-set in ascending order by movie year.
    Return movie ID, movie title and movie release year.
 */

SELECT MOV_ID, MOV_TITLE, MOV_YEAR
FROM MOVIE
WHERE MOV_TITLE LIKE '%Boogie Nights%'
ORDER BY MOV_YEAR ASC;

/*
10. From the following table, write a SQL query to find those actors with the first name 'Woody' and the last name 'Allen'.
    Return actor ID.
 */

SELECT ACT_ID
FROM ACTOR
WHERE ACT_FNAME = 'Woody' AND ACT_LNAME = 'Allen';

/*
 11. From the following table, write a SQL query to find the actors who played a role in the movie 'Annie Hall'.
     Return all the fields of actor table.
 */

SELECT *
FROM ACTOR
WHERE ACT_ID IN (
    SELECT ACT_ID
    FROM MOVIE_CAST
    JOIN MOVIE ON MOVIE_CAST.MOV_ID = MOVIE.MOV_ID
    WHERE MOV_TITLE = 'Annie Hall'
    );

/*
 12. From the following tables, write a SQL query to find those movies, which have received highest number of stars. Group the result set on movie title and sorts the result-set in ascending order by movie title.
     Return movie title and maximum number of review stars.
 */

SELECT M.MOV_TITLE, MAX(R.REV_STARS) AS MAX
FROM MOVIE M
JOIN RATING R ON M.MOV_ID = R.MOV_ID AND R.REV_STARS IS NOT NULL
GROUP BY M.MOV_TITLE
ORDER BY MAX DESC;

/*
 13. From the following tables, write a SQL query to find all reviewers who rated the movie 'American Beauty'.
     Return reviewer name.
 */

SELECT REV.REV_NAME
FROM REVIEWER REV
JOIN RATING R ON REV.REV_ID = R.REV_ID AND MOV_ID = (
    SELECT MOV_ID
    FROM MOVIE
    WHERE MOV_TITLE = 'American Beauty'
    );

/*
 14. From the following table, write a SQL query to find the movies that have not been reviewed by any reviewer body other than 'Paul Monks'.
     Return movie title.
 */

SELECT MOV.MOV_TITLE
FROM MOVIE MOV
JOIN RATING R ON MOV.MOV_ID = R.MOV_ID
WHERE R.MOV_ID IN (
    SELECT R2.MOV_ID
    FROM RATING R2
    JOIN REVIEWER REV ON R2.REV_ID = REV.REV_ID
    WHERE REV.REV_NAME = 'Paul Monks'
    )
AND R.MOV_ID NOT IN (
    SELECT R2.MOV_ID
    FROM RATING R2
    JOIN REVIEWER REV ON R2.REV_ID = REV.REV_ID
    WHERE REV.REV_NAME <> 'Paul Monks'
    );

/*
 15. From the following table, write a SQL query to find the movies with the lowest ratings.
     Return reviewer name, movie title, and number of stars for those movies
 */

SELECT REV.REV_NAME, MOV.MOV_TITLE, R.REV_STARS
FROM MOVIE MOV
JOIN RATING R ON R.MOV_ID = MOV.MOV_ID
JOIN REVIEWER REV ON R.REV_ID = REV.REV_ID
WHERE R.REV_STARS IN (
    SELECT MIN(R2.REV_STARS)
    FROM RATING R2
    );

/*
 16. Write a query in SQL to find the movies in which one or more actors appeared in more than one film
 */

SELECT MOV.MOV_ID, MOV.MOV_TITLE, MC.ACT_ID
FROM MOVIE MOV
JOIN MOVIE_CAST MC ON MOV.MOV_ID = MC.MOV_ID
WHERE MC.ACT_ID IN (
    SELECT MC2.ACT_ID
    FROM MOVIE_CAST MC2
    WHERE MC2.MOV_ID <> MC.MOV_ID
    );

/*
 17. From the following table, write a SQL query to find all reviewers whose ratings contain a NULL value.
     Return reviewer name.
 */

SELECT REV.REV_ID, REV.REV_NAME, R.MOV_ID
FROM REVIEWER REV
LEFT JOIN RATING R ON REV.REV_ID = R.REV_ID
WHERE R.MOV_ID IS NULL;

/*
 18. From the following table, write a SQL query to find out who was cast in the movie 'Annie Hall'.
     Return actor first name, last name and role.
 */

SELECT a.ACT_ID, A.ACT_FNAME, A.ACT_LNAME, MC.ROLE
FROM ACTOR A
JOIN MOVIE_CAST MC ON A.ACT_ID = MC.ACT_ID AND MC.MOV_ID = (
    SELECT MOV_ID
    FROM MOVIE
    WHERE MOV_TITLE = 'Annie Hall'
    );

/*
 19. From the following tables, write a SQL query to find the director of a movie that cast a role as Sean Maguire.
     Return director first name, last name and movie title.
 */

SELECT D.DIR_FNAME, D.DIR_LNAME, M.MOV_TITLE
FROM DIRECTOR D
JOIN MOVIE_DIRECTION MD ON MD.DIR_ID = D.DIR_ID
JOIN MOVIE M ON MD.MOV_ID = M.MOV_ID
JOIN MOVIE_CAST MC ON MC.MOV_ID = M.MOV_ID
WHERE MC.ROLE = 'Sean Maguire';

/*
 20. From the following table, write a SQL query to find out which actors have not appeared in any movies between 1990 and 2000 (Begin and end values are included.).
     Return actor first name, last name, movie title and release yea
 */

SELECT A.ACT_FNAME, A.ACT_LNAME, M.MOV_TITLE, M.MOV_YEAR
FROM ACTOR A
JOIN MOVIE_CAST MC ON MC.ACT_ID = A.ACT_ID
JOIN MOVIE M ON MC.MOV_ID = M.MOV_ID AND M.MOV_YEAR NOT BETWEEN 1990 AND 2000;


/*
 21. From the following table, write a SQL query to find the directors who have directed films in a variety of genres.
     Group the result set on director first name, last name and generic title.
     Sort the result-set in ascending order by director first name and last name.
     Return director first name, last name and number of genres movies.
 */

 SELECT D.DIR_FNAME, D.DIR_LNAME, G.GEN_TITLE, COUNT(M.MOV_ID) AS NR_MOV
 FROM DIRECTOR D
 JOIN MOVIE_DIRECTION MD ON MD.DIR_ID = D.DIR_ID
 JOIN MOVIE M ON MD.MOV_ID = M.MOV_ID
 JOIN MOVIE_GENRES MG ON MG.MOV_ID = M.MOV_ID
 JOIN GENRES G ON MG.GEN_ID = G.GEN_ID
 GROUP BY D.DIR_FNAME, D.DIR_LNAME, G.GEN_TITLE
 ORDER BY D.DIR_FNAME, D.DIR_LNAME, NR_MOV;

 /*
  22. From the following tables, write a SQL query to find the movies released before 1st January 1989.
      Sort the result-set in descending order by date of release.
      Return movie title, release year, date of release, duration, and first and last name of the director.
  */

SELECT M.MOV_TITLE, M.MOV_YEAR, M.MOV_DT_REL, M.MOV_TIME, D.DIR_FNAME, D.DIR_LNAME
FROM MOVIE M
JOIN MOVIE_DIRECTION MD ON MD.MOV_ID = M.MOV_ID
JOIN DIRECTOR D ON MD.DIR_ID = D.DIR_ID
WHERE M.MOV_DT_REL < TO_DATE('01-JANUARY-1989', 'DD-MONTH-YYYY');

/*
 23. From the following table, write a SQL query to calculate the average movie length and count the number of movies in each genre.
     Return genre title, average time and number of movies for each genre.
 */

SELECT G.GEN_TITLE, AVG(M.MOV_TIME) AS AVG_LENGTH, SUM(M.MOV_ID) AS NR_MOV
FROM MOVIE M
JOIN MOVIE_GENRES MG ON MG.MOV_ID = M.MOV_ID
JOIN GENRES G ON MG.GEN_ID = G.GEN_ID
GROUP BY G.GEN_TITLE;

/*
 24. From the following table, write a SQL query to find movies with the shortest duration.
     Return movie title, movie year, director first name, last name, actor first name, last name and role.
 */

SELECT M.MOV_TITLE, M.MOV_YEAR, D.DIR_FNAME, D.DIR_LNAME, A.ACT_FNAME, A.ACT_LNAME, MC.ROLE
FROM MOVIE M
LEFT JOIN MOVIE_DIRECTION MD ON MD.MOV_ID = M.MOV_ID
LEFT JOIN DIRECTOR D ON MD.DIR_ID = D.DIR_ID
LEFT JOIN MOVIE_CAST MC ON MC.MOV_ID = M.MOV_ID
LEFT JOIN ACTOR A ON MC.ACT_ID = A.ACT_ID
WHERE M.MOV_TIME = (
    SELECT MIN(M2.MOV_TIME)
    FROM MOVIE M2
    );

/*
 25. From the following table, write a SQL query to find the years in which a movie received a rating of 3 or 4.
     Sort the result in increasing order on movie year.
 */

SELECT DISTINCT M.MOV_YEAR
FROM MOVIE M
JOIN RATING R ON R.MOV_ID = M.MOV_ID AND R.REV_STARS BETWEEN 3 AND 4;

/*
 26. From the following table, write a SQL query to find those movies that have at least one rating and received the most stars.
     Sort the result-set on movie title. Return movie title and maximum review stars.
 */

SELECT M.MOV_ID, M.MOV_TITLE, MAX(R.REV_STARS) AS MAX_REV_STARS
FROM MOVIE M
JOIN RATING R ON R.MOV_ID = M.MOV_ID
GROUP BY M.MOV_TITLE, M.MOV_ID
ORDER BY M.MOV_TITLE;

/*
 27. From the following table, write a SQL query to find movies in which one or more actors have acted in more than one film.
     Return movie title, actor first and last name, and the role.
 */

SELECT M.MOV_TITLE, A.ACT_FNAME, A.ACT_LNAME, MC.ROLE
FROM MOVIE M
JOIN MOVIE_CAST MC ON M.MOV_ID = MC.MOV_ID
JOIN ACTOR A ON MC.ACT_ID = A.ACT_ID
WHERE MC.ACT_ID IN (
    SELECT MC2.ACT_ID
    FROM MOVIE_CAST MC2
    GROUP BY MC2.ACT_ID
    HAVING COUNT(MC2.MOV_ID) >= 2
    );

/*
 28. From the following table, write a SQL query to find for actors whose films have been directed by them.
     Return actor first name, last name, movie title and role.
 */

SELECT A.ACT_FNAME, A.ACT_LNAME, M.MOV_TITLE, MC.ROLE
FROM ACTOR A
JOIN MOVIE_CAST MC ON MC.ACT_ID = A.ACT_ID
JOIN MOVIE M ON MC.MOV_ID = M.MOV_ID
JOIN MOVIE_DIRECTION MD ON MD.MOV_ID = M.MOV_ID
JOIN DIRECTOR D ON MD.DIR_ID = D.DIR_ID
                AND ((A.ACT_FNAME = D.DIR_FNAME) AND (A.ACT_LNAME = D.DIR_LNAME));

/*
 29. From the following tables, write a SQL query to find the highest-rated ‘Mystery Movies’.
     Return the title, year, and rating.
 */

SELECT M.MOV_TITLE, M.MOV_YEAR, R.REV_STARS
FROM MOVIE M
JOIN RATING R ON R.MOV_ID = M.MOV_ID
JOIN MOVIE_GENRES MG ON MG.MOV_ID = M.MOV_ID
JOIN GENRES G ON MG.GEN_ID = G.GEN_ID
AND G.GEN_TITLE = 'Mystery'
WHERE R.REV_STARS = (
    SELECT MAX(R2.REV_STARS)
    FROM RATING R2
    JOIN MOVIE_GENRES MG2 ON R2.MOV_ID = MG2.MOV_ID
    JOIN GENRES G2 ON MG2.GEN_ID = G2.GEN_ID
    WHERE G2.GEN_TITLE = 'Mystery'
    );

/*
 30. From the following tables, write a SQL query to find the years when most of the ‘Mystery Movies’ produced.
     Count the number of generic title and compute their average rating.
     Group the result set on movie release year, generic title.
     Return movie year, generic title, number of generic title and average rating.
 */

SELECT M.MOV_YEAR, G.GEN_TITLE, COUNT(M.MOV_ID) AS COUNT, AVG(R.REV_STARS)
FROM MOVIE M
JOIN MOVIE_GENRES MG ON MG.MOV_ID = M.MOV_ID
JOIN GENRES G ON MG.GEN_ID = G.GEN_ID AND G.GEN_TITLE = 'Mystery'
LEFT JOIN RATING R ON R.MOV_ID = M.MOV_ID
GROUP BY M.MOV_YEAR, G.GEN_TITLE
HAVING COUNT(M.MOV_ID) = (
    SELECT MAX(COUNT(M2.MOV_ID))
    FROM MOVIE M2
    JOIN MOVIE_GENRES MG2 ON M2.MOV_ID = MG2.MOV_ID
    JOIN GENRES G2 ON MG2.GEN_ID = G2.GEN_ID AND G2.GEN_TITLE = 'Mystery'
    GROUP BY M2.MOV_YEAR
    );
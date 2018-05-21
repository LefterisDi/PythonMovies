SELECT * FROM actor;

SELECT * FROM movie;

SELECT * FROM genre;


SELECT DISTINCT mv.title , rl1.actor_id , rl2.actor_id , 159346 , 68424

FROM movie mv , role rl1 , role rl2

WHERE     rl1.actor_id < rl2.actor_id
	  AND rl1.movie_id = rl2.movie_id
      AND rl1.actor_id <> 159346
      AND rl1.actor_id <> 68424
      AND rl2.actor_id <> 159346
      AND rl2.actor_id <> 68424

	  AND EXISTS(SELECT DISTINCT rl3.movie_id , rl4.movie_id
				 
                 FROM role nrl1 , role nrl2 , role rl3 , role rl4
                 
                 WHERE 	   rl3.actor_id = 159346
					   AND rl4.actor_id = 68424
                       AND nrl1.actor_id = rl1.actor_id
                       AND nrl2.actor_id = rl2.actor_id
                       AND rl3.movie_id = nrl1.movie_id
                       AND rl4.movie_id = nrl2.movie_id
                )

      AND rl1.movie_id = mv.movie_id
      
ORDER BY rl1.actor_id , rl2.actor_id
;




SELECT gen.genre_name , rl.actor_id , COUNT(rl.movie_id)

FROM genre gen , role rl , movie_has_genre mvhgen

WHERE     rl.movie_id = mvhgen.movie_id
	  AND mvhgen.genre_id = gen.genre_id
      
GROUP BY gen.genre_id , rl.actor_id

ORDER BY gen.genre_name , COUNT(rl.movie_id) DESC;






SELECT rl1.actor_id , rl2.actor_id

FROM role rl1 , role rl2

WHERE rl1.actor_id < rl2.actor_id
;




SELECT rl.actor_id , act.first_name , act.last_name

FROM movie mv , role rl , actor act

WHERE 	  rl.movie_id = mv.movie_id
	  AND rl.actor_id = act.actor_id
	  AND mv.title = "JFK";
      
      
SELECT DISTINCT mv.title

FROM movie mv , role rl1 , role rl2

WHERE     rl1.actor_id = 48468
      AND rl2.actor_id = 353656
      AND rl1.movie_id = rl2.movie_id
      AND mv.movie_id = rl1.movie_id

ORDER BY mv.title
      ;
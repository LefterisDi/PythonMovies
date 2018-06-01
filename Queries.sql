SELECT * FROM actor;

SELECT * FROM role;

SELECT * FROM movie;

SELECT * FROM genre;

/* ~~~~~~~~~~~~~~~~~~~~~~~~~~  colleaguesOfColleagues  ~~~~~~~~~~~~~~~~~~~~~~~~~~ */

SELECT DISTINCT mv.title , rl1.actor_id , rl2.actor_id , 353656 , 308572

FROM movie mv , role rl1 , role rl2

WHERE     rl1.actor_id <> rl2.actor_id
	  AND rl1.movie_id = rl2.movie_id
      AND rl1.actor_id <> 22591
      AND rl2.actor_id <> 3226

	  AND EXISTS(SELECT DISTINCT rl3.movie_id , rl4.movie_id
				 
                 FROM role nrl1 , role nrl2 , role rl3 , role rl4
                 
                 WHERE 	   rl3.actor_id = 22591
					   AND rl4.actor_id = 3226
                       AND nrl1.actor_id = rl1.actor_id
                       AND nrl2.actor_id = rl2.actor_id
                       AND rl3.movie_id = nrl1.movie_id
                       AND rl4.movie_id = nrl2.movie_id
                )

      AND rl1.movie_id = mv.movie_id
      
ORDER BY rl1.actor_id , rl2.actor_id;




SELECT DISTINCT mv.title , rl1.actor_id , rl2.actor_id , 353656 , 308572

FROM movie mv , role rl1 , role rl2

WHERE     rl1.actor_id <> rl2.actor_id
	  AND rl1.movie_id = rl2.movie_id
      
	  AND rl1.actor_id <> 22591
      AND rl2.actor_id <> 3226

	  AND EXISTS(SELECT DISTINCT rl3.movie_id , rl4.movie_id
				 
                 FROM role nrl1 , role nrl2 , role rl3 , role rl4
                 
                 WHERE 	   rl3.actor_id = 22591
					   AND rl4.actor_id = 3226
                       
                       AND nrl1.actor_id = rl1.actor_id
                       AND nrl2.actor_id = rl2.actor_id
                       AND nrl1.movie_id = rl3.movie_id
                       AND nrl2.movie_id = rl4.movie_id
                )

      AND rl1.movie_id = mv.movie_id
      
ORDER BY rl1.actor_id , rl2.actor_id;




SELECT DISTINCT mv.title , c.actor_id , d.actor_id , 22591 , 3226

FROM movie mv , role c , role d

WHERE     c.movie_id = d.movie_id
	  AND c.actor_id <> d.actor_id
      AND c.actor_id <> 22591
      AND d.actor_id <> 3226
      
      AND EXISTS (SELECT DISTINCT a.movie_id

				  FROM role a , role tmp_c

				  WHERE     a.actor_id = 22591
						AND tmp_c.actor_id = c.actor_id
						AND tmp_c.movie_id = a.movie_id
				 )
                  
      AND EXISTS (SELECT DISTINCT b.movie_id

				  FROM role b , role tmp_d

				  WHERE     b.actor_id = 3226
					    AND tmp_d.actor_id = d.actor_id
						AND tmp_d.movie_id = b.movie_id
				 )

      AND c.movie_id = mv.movie_id
      
ORDER BY c.actor_id , d.actor_id;


/* ~~~~~~~~~~~~~~~~~~~~~~~~~~  colleaguesOfColleagues  ~~~~~~~~~~~~~~~~~~~~~~~~~~ */

/* ~~~~~~~~~~~~~~~~~~~~~~~~~~  !!!!!!!!!!!!!!!!!!!!!!  ~~~~~~~~~~~~~~~~~~~~~~~~~~ */

/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  actorPairs  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */

SELECT DISTINCT act2.actor_id

             FROM actor act1 , actor act2 ,
                  role rl1 ,  role rl3 , role rl4 ,
                  movie mv1 ,movie mv3 , movie mv4 ,
                  genre gen1 ,  genre gen3 , genre gen4 ,
                  movie_has_genre mvhg1  ,movie_has_genre mvhg3 , movie_has_genre mvhg4

             WHERE     act1.actor_id = 353656
                   AND rl1.actor_id = act1.actor_id
                   AND rl1.movie_id = mv1.movie_id
                   AND mvhg1.genre_id = gen1.genre_id
                   AND mvhg1.movie_id = mv1.movie_id

    			   AND rl3.actor_id = act1.actor_id
                   AND rl3.movie_id = mv3.movie_id
                   AND mvhg3.genre_id = gen3.genre_id
                   AND mvhg3.movie_id = mv3.movie_id

    			   AND rl4.actor_id = act2.actor_id
                   AND rl4.movie_id = mv4.movie_id
                   AND mvhg4.genre_id = gen4.genre_id
                   AND mvhg4.movie_id = mv4.movie_id

    	           AND NOT EXISTS(SELECT gen2.genre_id

                                  FROM role rl2 , movie mv2 , genre gen2 , movie_has_genre mvhg2

    							  WHERE     gen1.genre_id = gen2.genre_id
                                        AND	rl2.actor_id = act2.actor_id
            							AND	rl2.movie_id = mv2.movie_id
            							AND mvhg2.genre_id = gen2.genre_id
            							AND mvhg2.movie_id = mv2.movie_id
                                 )

GROUP BY act2.actor_id
HAVING COUNT(DISTINCT gen1.genre_id) = COUNT(DISTINCT gen3.genre_id)
   AND COUNT(DISTINCT gen1.genre_id) + COUNT(DISTINCT gen4.genre_id) > 7;





SELECT DISTINCT rl2.actor_id

             FROM role rl1 , role rl2 , role rl3 , role rl4 ,
                  movie_has_genre mvhg1 , movie_has_genre mvhg2 , movie_has_genre mvhg3

             WHERE     rl1.actor_id = 353656
                   AND rl1.movie_id = mvhg1.movie_id

    			   AND rl3.actor_id = rl1.actor_id
                   AND rl3.movie_id = mvhg2.movie_id

    			   AND rl4.actor_id = rl2.actor_id
                   AND rl4.movie_id = mvhg3.movie_id

    	           AND NOT EXISTS(SELECT mvhg.genre_id

                                  FROM role rl , movie_has_genre mvhg

    							  WHERE     mvhg1.genre_id = mvhg.genre_id
            							AND rl.actor_id = rl2.actor_id
                                        AND rl.movie_id = mvhg.movie_id
                                 )

GROUP BY rl2.actor_id
HAVING COUNT(DISTINCT mvhg1.genre_id) = COUNT(DISTINCT mvhg2.genre_id)
   AND COUNT(DISTINCT mvhg1.genre_id) + COUNT(DISTINCT mvhg3.genre_id) > 7;



SELECT DISTINCT rl.actor_id

FROM role rl

WHERE     NOT EXISTS(SELECT DISTINCT mvhgen.genre_id
					 
				     FROM role nrl , movie_has_genre mvhgen
							 
				     WHERE 	   nrl.actor_id = rl.actor_id
						   AND rl.movie_id = mvhgen.movie_id
				   
						   AND mvhgen.genre_id IN (SELECT DISTINCT mvhgen.genre_id
							
												   FROM role rl , movie_has_genre mvhgen
													
												   WHERE     rl.actor_id = 353656
														 AND rl.movie_id = mvhgen.movie_id
												  ))
      AND (SELECT COUNT(DISTINCT mvhgen.genre_id)
					 
			 FROM role nrl , movie_has_genre mvhgen
					 
			 WHERE 	   nrl.actor_id = rl.actor_id
				   AND rl.movie_id = mvhgen.movie_id
		  ) +
	   
          (SELECT COUNT(DISTINCT mvhgen.genre_id)

		   FROM role rl , movie_has_genre mvhgen
				
		   WHERE     rl.actor_id = 353656
				 AND rl.movie_id = mvhgen.movie_id
		  ) > 7;
          
          

          

SELECT DISTINCT rl.actor_id , COUNT(DISTINCT mvhgen.genre_id) , COUNT(DISTINCT gmvhgen.genre_id)

FROM role rl , role trl , role grl , movie_has_genre mvhgen , movie_has_genre gmvhgen

WHERE     trl.actor_id = rl.actor_id
	  AND trl.movie_id = mvhgen.movie_id
      AND grl.actor_id = 353656
      AND grl.movie_id = gmvhgen.movie_id


AND NOT EXISTS(SELECT DISTINCT mvhgen.genre_id
					 
				     FROM role nrl , movie_has_genre mvhgen
							 
				     WHERE 	   nrl.actor_id = rl.actor_id
						   AND rl.movie_id = mvhgen.movie_id
				   
						   AND mvhgen.genre_id IN (SELECT DISTINCT mvhgen.genre_id
							
												   FROM role rl , movie_has_genre mvhgen
													
												   WHERE     rl.actor_id = 353656
														 AND rl.movie_id = mvhgen.movie_id
												  ))
GROUP BY rl.actor_id HAVING COUNT(DISTINCT mvhgen.genre_id) + COUNT(DISTINCT gmvhgen.genre_id) > 7
											;




SELECT DISTINCT rl.actor_id

FROM role rl , role tmp_rl , role gvn_rl , movie_has_genre mvhgen , movie_has_genre gvn_mvhgen

WHERE     tmp_rl.actor_id = rl.actor_id
	  AND tmp_rl.movie_id = mvhgen.movie_id
      AND gvn_rl.actor_id = 64724
      AND gvn_rl.movie_id = gvn_mvhgen.movie_id

	  AND NOT EXISTS(SELECT DISTINCT mvhgen.genre_id
					 
				     FROM role nrl , movie_has_genre mvhgen
							 
				     WHERE 	   nrl.actor_id = rl.actor_id
						   AND rl.movie_id = mvhgen.movie_id
				   
						   AND mvhgen.genre_id IN (SELECT DISTINCT mvhgen.genre_id
							
												   FROM role rl , movie_has_genre mvhgen
													
												   WHERE     rl.actor_id = 64724
														 AND rl.movie_id = mvhgen.movie_id
												  ))
                                                  
GROUP BY rl.actor_id HAVING COUNT(DISTINCT mvhgen.genre_id) + COUNT(DISTINCT gvn_mvhgen.genre_id) > 7;






SELECT DISTINCT rl.actor_id

FROM role rl , role tmp_rl , role gvn_rl , 
	 movie_has_genre tmp_mvhgen , movie_has_genre gvn_mvhgen

WHERE     tmp_rl.actor_id = rl.actor_id
	  AND tmp_rl.movie_id = tmp_mvhgen.movie_id
      AND gvn_rl.actor_id = 3226
      AND gvn_rl.movie_id = gvn_mvhgen.movie_id

	  AND (SELECT COUNT(DISTINCT ntmp_mvhgen.genre_id)
					 
		   FROM role ntmp_rl , role ngvn_rl , 
				movie_has_genre ntmp_mvhgen , movie_has_genre ngvn_mvhgen
				 
		   WHERE 	 ntmp_rl.actor_id = rl.actor_id
			     AND ntmp_rl.movie_id = ntmp_mvhgen.movie_id
				 AND ngvn_rl.actor_id = 3226
				 AND ngvn_rl.movie_id = ngvn_mvhgen.movie_id
				 AND ntmp_mvhgen.genre_id = ngvn_mvhgen.genre_id
		  ) = 0
                                                  
GROUP BY rl.actor_id HAVING COUNT(DISTINCT tmp_mvhgen.genre_id) + COUNT(DISTINCT gvn_mvhgen.genre_id) >= 7;

                                                  

/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  actorPairs  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */


/* ~~~~~~~~~~~~~~ VALIDATION ~~~~~~~~~~~~~~ */
        
SELECT DISTINCT rl.actor_id , COUNT(DISTINCT tmp_mvhgen.genre_id) + 4

FROM role rl , role tmp_rl , role gvn_rl , 
	 movie_has_genre tmp_mvhgen , movie_has_genre gvn_mvhgen

WHERE     tmp_rl.actor_id = rl.actor_id
	  AND tmp_rl.movie_id = tmp_mvhgen.movie_id
      AND gvn_rl.actor_id = 7817
      AND gvn_rl.movie_id = gvn_mvhgen.movie_id

	  AND (SELECT COUNT(DISTINCT ntmp_mvhgen.genre_id)
					 
		   FROM role ntmp_rl , role ngvn_rl , 
				movie_has_genre ntmp_mvhgen , movie_has_genre ngvn_mvhgen
				 
		   WHERE 	 ntmp_rl.actor_id = rl.actor_id
			     AND ntmp_rl.movie_id = ntmp_mvhgen.movie_id
				 AND ngvn_rl.actor_id = 7817
				 AND ngvn_rl.movie_id = ngvn_mvhgen.movie_id
				 AND ntmp_mvhgen.genre_id = ngvn_mvhgen.genre_id
		  ) = 0
                                                  
GROUP BY rl.actor_id

ORDER BY COUNT(DISTINCT tmp_mvhgen.genre_id) DESC;

   



SELECT DISTINCT gen.genre_name
					 
		   FROM role rl , movie_has_genre mvhgen , genre gen
                     
		   WHERE 	 rl.actor_id = 22591
				 AND rl.movie_id = mvhgen.movie_id
                 AND mvhgen.genre_id = gen.genre_id
;


SELECT DISTINCT mvhgen.genre_id
					 
		   FROM movie_has_genre mvhgen
                     
		   WHERE mvhgen.movie_id = 333856
;

SELECT * FROM actor;



/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  Top N actors  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */


SELECT gen.genre_name , rl.actor_id , COUNT(rl.movie_id)

FROM genre gen , role rl , movie_has_genre mvhgen

WHERE     rl.movie_id = mvhgen.movie_id
	  AND mvhgen.genre_id = gen.genre_id
      
GROUP BY gen.genre_id , rl.actor_id

ORDER BY gen.genre_name , COUNT(rl.movie_id) DESC , rl.actor_id;


/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  Top N actors  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ */



SELECT rl1.actor_id , rl2.actor_id

FROM role rl1 , role rl2

WHERE rl1.actor_id < rl2.actor_id
;




SELECT rl.actor_id , act.first_name , act.last_name

FROM movie mv , role rl , actor act

WHERE 	  rl.movie_id = mv.movie_id
	  AND rl.actor_id = act.actor_id
	  AND mv.title = "Few Good Men, A";
      
      
SELECT DISTINCT mv.title

FROM movie mv , role rl1 , role rl2

WHERE     rl1.actor_id = 22591
      AND (rl2.actor_id = 308572 OR rl2.actor_id = 353656)
      AND rl1.movie_id = rl2.movie_id
      AND mv.movie_id = rl1.movie_id

ORDER BY mv.title
      ;
      
      
      
      
SELECT DISTINCT mv.title

FROM movie mv , role rl1

WHERE     rl1.actor_id = 22591
      AND rl1.movie_id = mv.movie_id

ORDER BY mv.title
      ;
      
      
      
SELECT * FROM movie;



SELECT DISTINCT mv.title

FROM movie mv , role rl1 , role rl2

WHERE     rl1.actor_id = 68048
	  AND rl2.actor_id = 101879
      AND rl1.movie_id = rl2.movie_id
      AND rl1.movie_id = mv.movie_id

ORDER BY mv.title
      ;
      


SELECT DISTINCT 'yes' AS 'Answer'

FROM movie mv , role rl1 , role rl2

WHERE     rl1.movie_id = mv.movie_id
	  AND rl1.movie_id = rl2.movie_id
      AND mv.title = "JFK"
      AND rl1.actor_id = 48468
      AND rl2.actor_id = 54645

UNION

SELECT DISTINCT 'no' AS 'Answer'

FROM movie

WHERE NOT EXISTS(SELECT mv.movie_id
				 
                FROM movie mv , role rl1 , role rl2

				WHERE     rl1.movie_id = mv.movie_id
					  AND rl1.movie_id = rl2.movie_id
					  AND mv.title = "JFK"
					  AND rl1.actor_id = 48468
					  AND rl2.actor_id = 54645
                );


# ----- CONFIGURE YOUR EDITOR TO USE 4 SPACES PER TAB ----- #
import pymysql as db
import settings
import sys

def connection():
    ''' User this function to create your connections '''
    con = db.connect(
        settings.mysql_host,
        settings.mysql_user,
        settings.mysql_passwd,
        settings.mysql_schema)

    return con

def updateRank(rank1, rank2, movieTitle):

    # Create a new connection
    con = connection()

    # Create a cursor on the connection
    cur = con.cursor()

    try:
        float(rank1)
        if float(rank1) > 10.0 or float(rank1) < 0.0:
            return [("Status",),("Error",),]
    except ValueError:
        return [("Status",),("Error",),]

    try:
        float(rank2)
        if float(rank2) > 10.0 or float(rank2) < 0.0:
            return [("Status",),("Error",),]
    except ValueError:
        return [("Status",),("Error",),]

    sql = "SELECT title , rank FROM movie;"

    try:
        cur.execute(sql) #executes sql
    except:
        con.rollback() #goes back in case of error

    unique = 1; #checks if the movie title is unique
    movRank = 0.0;
    for row in cur.fetchall():
        if row[0] == movieTitle and unique == 1:
            if unique == 0:
                return [("Status",),("Error",),]
            unique = 0
            movRank = row[1]

    if unique == 1:
        return [("Status",),("Error",),]

    if movRank is None:
        newRank = (float(rank1) + float(rank2)) / 2.0
    else:
        newRank = (movRank + float(rank1) + float(rank2)) / 3.0


    sql = "UPDATE movie SET movie.rank = %f WHERE movie.title = '%s';" % (newRank , movieTitle)

    try:
        cur.execute(sql) #executes sql
        con.commit() #commits changes
    except:
        con.rollback() #goes back in case of error

    print(movRank , newRank)

    print (rank1, rank2, movieTitle)

    cur.close()
    con.close()

    return [("Status",),("Ok!",),]





def colleaguesOfColleagues(actorId1, actorId2):

    # Create a new connection
    con = connection()

    # Create a cursor on the connection
    cur = con.cursor()

    try:
        int(actorId1)
    except ValueError:
        return [("Status",),("Error",),]

    try:
        int(actorId2)
    except ValueError:
        return [("Status",),("Error",),]

    list = [("Movie Title" , "Colleague of Actor_1" , "Colleague of Actor_2" , "Actor 1" , "Actor 2"),]

    sql = """
              SELECT DISTINCT mv.title , rl1.actor_id , rl2.actor_id , %s , %s

              FROM movie mv , role rl1 , role rl2

              WHERE     rl1.actor_id < rl2.actor_id
             	    AND rl1.movie_id = rl2.movie_id
                    AND rl1.actor_id <> %s
                    AND rl1.actor_id <> %s
                    AND rl2.actor_id <> %s
                    AND rl2.actor_id <> %s

            	    AND EXISTS(SELECT DISTINCT rl3.movie_id , rl4.movie_id

                               FROM role nrl1 , role nrl2 , role rl3 , role rl4

                               WHERE     rl3.actor_id = %s
            					     AND rl4.actor_id = %s
                                     AND nrl1.actor_id = rl1.actor_id
                                     AND nrl2.actor_id = rl2.actor_id
                                     AND rl3.movie_id = nrl1.movie_id
                                     AND rl4.movie_id = nrl2.movie_id
                              )

                    AND rl1.movie_id = mv.movie_id

              ORDER BY rl1.actor_id , rl2.actor_id;

          """ % (actorId1 , actorId2 , actorId1 , actorId2 , actorId1 , actorId2 , actorId1 , actorId2)

    try:
        cur.execute(sql) #executes sql
        con.commit() #commits changes
    except:
        con.rollback() #goes back in case of error

    for i in cur:
        list.append(i)

    try:
        int(actorId1)
    except ValueError:
        return [("Status",),("Error",),]

    try:
        int(actorId2)
    except ValueError:
        return [("Status",),("Error",),]

    list = [("Movie Title" , "Colleague of Actor_1" , "Colleague of Actor_2" , "Actor 1" , "Actor 2"),]

    sql = """
              SELECT DISTINCT mv.title , rl1.actor_id , rl2.actor_id , %s , %s

              FROM movie mv , role rl1 , role rl2

              WHERE     rl1.actor_id < rl2.actor_id
             	    AND rl1.movie_id = rl2.movie_id
                    AND rl1.actor_id <> %s
                    AND rl1.actor_id <> %s
                    AND rl2.actor_id <> %s
                    AND rl2.actor_id <> %s

            	    AND EXISTS(SELECT DISTINCT rl3.movie_id , rl4.movie_id

                               FROM role nrl1 , role nrl2 , role rl3 , role rl4

                               WHERE     rl3.actor_id = %s
            					     AND rl4.actor_id = %s
                                     AND nrl1.actor_id = rl1.actor_id
                                     AND nrl2.actor_id = rl2.actor_id
                                     AND rl3.movie_id = nrl1.movie_id
                                     AND rl4.movie_id = nrl2.movie_id
                              )

                    AND rl1.movie_id = mv.movie_id

              ORDER BY rl1.actor_id , rl2.actor_id;

          """ % (actorId1 , actorId2 , actorId1 , actorId2 , actorId1 , actorId2 , actorId1 , actorId2)

    try:
        cur.execute(sql) #executes sql
        con.commit() #commits changes
    except:
        con.rollback() #goes back in case of error

    for i in cur:
        list.append(i)

    print (actorId1, actorId2)

    cur.close()
    con.close()

    return list;





def actorPairs(actorId):

    # Create a new connection
    con=connection()

    # Create a cursor on the connection
    cur=con.cursor()

    sql = """SELECT DISTINCT act2.actor_id
             FROM actor act1 , actor act2 ,
                  role rl1 ,  role rl3 , role rl4 ,
                  movie mv1 ,movie mv3 , movie mv4 ,
                  genre gen1 ,  genre gen3 , genre gen4 ,
                  movie_has_genre mvhg1  ,movie_has_genre mvhg3 , movie_has_genre mvhg4

             WHERE  act1.actor_id = %d
             AND	rl1.actor_id = act1.actor_id
             AND	rl1.movie_id = mv1.movie_id
             AND    mvhg1.genre_id = gen1.genre_id
             AND    mvhg1.movie_id = mv1.movie_id

			 AND	rl3.actor_id = act1.actor_id
             AND	rl3.movie_id = mv3.movie_id
             AND    mvhg3.genre_id = gen3.genre_id
             AND    mvhg3.movie_id = mv3.movie_id

			 AND	rl4.actor_id = act2.actor_id
             AND	rl4.movie_id = mv4.movie_id
             AND    mvhg4.genre_id = gen4.genre_id
             AND    mvhg4.movie_id = mv4.movie_id

	         AND NOT EXISTS(SELECT gen2.genre_id
							FROM 	role rl2 ,
									movie mv2 ,
									genre gen2 ,
									movie_has_genre mvhg2

							WHERE gen1.genre_id = gen2.genre_id
                            AND	rl2.actor_id = act2.actor_id
							AND	rl2.movie_id = mv2.movie_id
							AND mvhg2.genre_id = gen2.genre_id
							AND mvhg2.movie_id = mv2.movie_id)

			GROUP BY act2.actor_id
            HAVING COUNT(DISTINCT gen1.genre_id) = COUNT(DISTINCT gen3.genre_id)
               AND COUNT(DISTINCT gen1.genre_id) + COUNT(DISTINCT gen4.genre_id) > 7;""" % (int(actorId))

    try:
        cur.execute(sql)
    except:
        return [("status",),("error",),]

    NameList = []
    for row in cur.fetchall():
        NameList.append(row[0])

    print ("actor2Id")

    i = 0
    while i<len(NameList):
        print (NameList[i])
        i = i +1

    cur.close()
    con.close()

    return [("actor2Id",),(NameList,),]








def selectTopNactors(n):

    # Create a new connection
    con = connection()

    # Create a cursor on the connection
    cur = con.cursor()

    try:
        int(n)
        if int(n) < 0:
            return [("Status",),("Error",),]
    except ValueError:
        return [("Status",),("Error",),]

    list = [("Genre" , "Actor ID" , "# Movies"),]


    sql = """
              SELECT gen.genre_name , rl.actor_id , COUNT(rl.movie_id)

              FROM genre gen , role rl , movie_has_genre mvhgen

              WHERE     rl.movie_id = mvhgen.movie_id
            	    AND mvhgen.genre_id = gen.genre_id

              GROUP BY gen.genre_id , rl.actor_id

              ORDER BY gen.genre_name , COUNT(rl.movie_id) DESC;
          """

    try:
        cur.execute(sql) #executes sql
        con.commit() #commits changes
    except:
        con.rollback() #goes back in case of error


    arr = cur.fetchall()
    n_cntr = 0
    currGen = arr[0][0]

    for i,j in zip(range(0,len(arr)) , arr):
        if arr[i][0] != currGen:
            n_cntr = 0

        if n_cntr < int(n):
            list.append(j)
            n_cntr += 1

        currGen = arr[i][0]

    print (n)

    return list

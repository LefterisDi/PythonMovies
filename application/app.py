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
            return [("status",),("error",),]
    except ValueError:
        return [("status",),("error",),]
    try:
        float(rank2)
        if float(rank2) > 10.0 or float(rank2) < 0.0:
            return [("status",),("error",),]
    except ValueError:
        return [("status",),("error",),]

    sql = "SELECT title , rank FROM movie;"
    cur.execute(sql)

    unique = 1; #checks if the movie title is unique
    movRank = 0.0;
    for row in cur.fetchall():
        if row[0] == movieTitle and unique == 1:
            if unique == 0:
                return [("status",),("error",),]
            unique = 0
            movRank = row[1]

    if unique == 1:
        return [("status",),("error",),]

    newRank = (movRank + float(rank1) + float(rank2)) / 3.0

    sql = "UPDATE movie SET movie.rank = %f WHERE movie.title = '%s';" % (newRank , movieTitle)

    try:
        cur.execute(sql) #executes sql
        con.commit() #commits changes
    except:
        con.rollback() #goes back in case of error

    print(movRank , newRank)

    print (rank1, rank2, movieTitle)

    return [("status",),("ok",),]





def colleaguesOfColleagues(actorId1, actorId2):

    # Create a new connection
    con=connection()

    # Create a cursor on the connection
    cur=con.cursor()

    print (actorId1, actorId2)

    return [("movieTitle", "colleagueOfActor1", "colleagueOfActor2", "actor1","actor2",),]







def actorPairs(actorId):

    # Create a new connection
    con=connection()

    # Create a cursor on the connection
    cur=con.cursor()


    print (actorId)

    return [("actor2Id",),]







def selectTopNactors(n):

    # Create a new connection
    con=connection()

    # Create a cursor on the connection
    cur=con.cursor()

    print (n)

    return [("genreName", "actorId", "numberOfMovies"),]

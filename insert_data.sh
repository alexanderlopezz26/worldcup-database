#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#TRUNCATE TABLE Y RESETAR SERIAL

TRUNCATE_RESULT=$($PSQL "TRUNCATE TABLE teams, games RESTART IDENTITY")

cat games.csv | while IFS=',' read cyear cround cwinner copponent cwinner_goals copponent_goals
do
  if [[ $cwinner != 'winner' ]]
  then

    #INSERT TEAMS INTO teams table
    INSERT_TEAMS_RESULTS=$($PSQL "INSERT INTO teams(name) VALUES('$cwinner')")
    INSERT_TEAMS_RESULTS=$($PSQL "INSERT INTO teams(name) VALUES('$copponent')")

    echo Insertantdo en teams los equipos $cwinner y $copponent

  fi
  
done

cat games.csv | while IFS=',' read cyear cround cwinner copponent cwinner_goals copponent_goals
do
  if [[ $cwinner != 'winner' ]]
  then
    #Obtener el id del ganador y el oponente
    WINNER_ID_RESULT=$($PSQL "SELECT team_id FROM teams WHERE name='$cwinner'")
    OPPONENT_ID_RESULT=$($PSQL "SELECT team_id FROM teams WHERE name='$copponent'")
    #insertar games 
    INSERT_GAMES_RESULTS=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) 
    VALUES($cyear, '$cround', $WINNER_ID_RESULT, $OPPONENT_ID_RESULT, $cwinner_goals, $copponent_goals)")

    echo Insertando en games: year: $cyear round :$cround winner: $WINNER_ID_RESULT opponent: $OPPONENT_ID_RESULT wgoals:$cwinner_goals opgoals$copponent_goals
  fi
  
done

#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#clears the rows of the table on each rerun
echo $($PSQL "TRUNCATE TABLE games,teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

if [[ $WINNER != "winner" ]]
then
    TEAM1_NAME=$($PSQL "SELECT name FROM teams WHERE name ='$WINNER'")
    #if a team name is not here then a new team name must be added
    if [[ -z $TEAM1_NAME ]]
    then
      #insert a new team
      INSERT_T1_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_T1_NAME == "INSERT 0 1" ]]
        then
        echo Team has been successfully inserted
      fi
    fi
  fi


  if [[ $OPPONENT != "opponent" ]]
  then
    TEAM2_NAME=$($PSQL "SELECT name FROM teams WHERE name ='$OPPONENT'")
    #if a team name is not here then a new team name must be added
    if [[ -z $TEAM2_NAME ]]
    then
      #insert a new team
      INSERT_T2_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_T2_NAME == "INSERT 0 1" ]]
      then
        echo Team has been successfully inserted
      fi
    fi
  fi

if [[ $YEAR != "year" ]]
    then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")

    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")

    INSERT_INTO_GAME=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES ($YEAR,'$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  
  if [[ $INSERT_INTO_GAME == "INSERT 0 1" ]]
  then
      echo Game has been added to database
  fi
fi
done
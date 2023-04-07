#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE games, teams")


cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WGOAL OGOAL
do 
  if [[ $YEAR != "year" ]]
  then
    # insert Winner into teams table 
    INSERT_RESULT_WINNER=$($PSQL "
    INSERT INTO teams(name)
    SELECT '$WINNER'
    WHERE NOT EXISTS (
        SELECT * FROM teams WHERE name = '$WINNER'
    )
    ")

    # insert Opponent into teams table 
    INSERT_RESULT_OPPONENT=$($PSQL "
    INSERT INTO teams(name)
    SELECT '$OPPONENT'
    WHERE NOT EXISTS (
        SELECT * FROM teams WHERE name = '$OPPONENT'
    )
    ")

    # get the winner id
    WINNER_ID=$($PSQL "
    SELECT team_id FROM teams WHERE name='$WINNER'
    ")

    # get the opponent id
    OPPONENT_ID=$($PSQL "
    SELECT team_id FROM teams WHERE name='$OPPONENT'
    ")

    # insert into the games
    INSERT_RESULT_WINNNER=$($PSQL "
    INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) 
    VALUES ( $YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WGOAL, $OGOAL)
    ")

  fi
done


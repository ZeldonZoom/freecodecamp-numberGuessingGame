#!/bin/bash

PSQL="psql --username=postgres --dbname=number_guess -t --no-align -c"

NUMBER_OF_GUESSES=0
SECRET_NUMBER=$(( $RANDOM % 1000 + 1 ))


echo "Enter your username:"
read USERNAME

GET_USER=$($PSQL "select user_id from users where username='$USERNAME';")
# echo $GET_USER
if [[ -z $GET_USER ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  ADD_USER=$($PSQL "insert into users(username) values('$USERNAME')")
else
  
  # echo $USER_ID $USER
  BEST_GAME=$($PSQL "select min(guesses) from games where user_id='$GET_USER';")
  
  GAMES_PLAYED=$($PSQL "select count(game_id) from games where user_id='$GET_USER';")
  echo Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses.
fi

while true
do
  echo "Guess the secret number between 1 and 1000:"
  read INPUT

  if ! [[ $INPUT =~ ^-?[0-9]+$ ]]; then
    echo "That is not an integer, guess again:"
  else
    NUMBER_OF_GUESSES=$(($NUMBER_OF_GUESSES + 1))
    # echo $COUNT
    if [ $INPUT -gt $SECRET_NUMBER ]; then
      echo "It's lower than that, guess again:"
    elif [ $INPUT -lt $SECRET_NUMBER ]; then
      echo "It's higher than that, guess again:"
    else
      echo You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!
      GET_ID=$($PSQL "select user_id from users where username='$USERNAME';")
      ADD_GAME=$($PSQL "insert into games(user_id, guesses) values($GET_ID, $NUMBER_OF_GUESSES)")
      break
    fi
  fi
done
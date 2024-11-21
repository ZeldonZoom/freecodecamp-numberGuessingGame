#!/bin/bash

PSQL="psql --username=postgres --dbname=number_guess -t --no-align -c"

COUNT=0
RANDOM_NUMBER=$(( $RANDOM % 1000 + 1 ))
echo $RANDOM_NUMBER

echo Enter your username:
read USERNAME

GET_USER=$($PSQL "select * from users where username='$USERNAME';")
echo $GET_USER
if [[ -z $GET_USER ]]
then
  echo Welcome, $USERNAME! It looks like this is your first time here.
  ADD_USER=$($PSQL "insert into users(username) values('$USERNAME')")
else
  IFS='|' read -r USER_ID USER <<< "$GET_USER"
  echo $USER_ID $USER
  GET_BEST_GUESS=$($PSQL "select guesses from users left join games on users.user_id=games.user_id where username='$GET_USER' order by guesses limit 1;")
  echo Welcome back, $USER! You have played games, and your best game took $GET_BEST_GUESS guesses.
fi

while true
do
  echo Guess the secret number between 1 and 1000:
  read INPUT

  if ! [[ $INPUT =~ ^-?[0-9]+$ ]]; then
    echo "That is not an integer, guess again:"
  else
    COUNT=$(($COUNT + 1))
    echo $COUNT
    if [ $INPUT -gt $RANDOM_NUMBER ]; then
      echo "It's lower than that, guess again:"
    elif [ $INPUT -lt $RANDOM_NUMBER ]; then
      echo "It's greater than that, guess again:"
    else
      echo You guessed it in $COUNT tries. The secret number was $RANDOM_NUMBER. Nice job!
      ADD_GAME=$($PSQL "insert into games(user_id, guesses) values($USER_ID, $COUNT)")
      break
    fi
  fi
done
#!/bin/bash

PSQL="psql --username=postgres --dbname=number_guess -t --no-align -c"

NUMBER_OF_GUESSES=0
SECRET_NUMBER=$(( $RANDOM % 1000 + 1 ))
echo $RANDOM_NUMBER

echo "Enter your username:"
read USERNAME

GET_USER=$($PSQL "select username from users where username='$USERNAME';")
# echo $GET_USER
if [[ -z $GET_USER ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  ADD_USER=$($PSQL "insert into users(username) values('$USERNAME')")
else
  
  # echo $USER_ID $USER
  BEST_GAME=$($PSQL "select guesses from users left join games on users.user_id=games.user_id where username='$GET_USER' order by guesses limit 1;")
  GAMES_PLAYED=$($PSQL "select count(guesses) from users left join games on users.user_id=games.user_id where username='arnav';")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
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
      echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
      GET_ID=$($PSQL "select user_id from users where username='$USERNAME';")
      ADD_GAME=$($PSQL "insert into games(user_id, guesses) values($GET_ID, $NUMBER_OF_GUESSES)")
      break
    fi
  fi
done
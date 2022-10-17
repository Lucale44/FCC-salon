#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

#echo $($PSQL "TRUNCATE TABLE customers, appointments, services")
#echo $($PSQL "INSERT INTO services(name, service_id) VALUES('cut', 1), ('perm', 2), ('highlights', 3), ('beard/mustache trim', 4), ('color', 5)")

HOME() {
  
echo -e "\nWelcome to my salon, how may we be of service?\n"

  SIDNAME=$($PSQL "SELECT service_id, name FROM services")
    echo "$SIDNAME" | while read SERVICE_ID BAR NAME
    do
      echo "$SERVICE_ID) $NAME"
    done
  read SERVICE_ID_SELECTED

  if [[ ! $SERVICE_ID_SELECTED =~ [1-5] ]]
  then
    echo "That is not a valid entry"
    HOME
  else
    echo "Please enter your phone number:"
    read CUSTOMER_PHONE 
  
    
    CHECK_EXIST=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

    if [[ -z $CHECK_EXIST ]]
    then
      echo -e "\nPlease enter your name:"
      read CUSTOMER_NAME

      REGISTER=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
      echo -e "\nPlease enter a time:"
      read SERVICE_TIME
    else
      echo -e "\nPlease enter a time:"
      read SERVICE_TIME
      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    fi

      BOOK=$($PSQL "INSERT INTO appointments(time) VALUES('$SERVICE_TIME')")
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
      COMBINE=$($PSQL "INSERT INTO appointments(customer_id, service_id) VALUES('$CUSTOMER_ID', '$SERVICE_ID_SELECTED')")
      NAME2=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
      echo -e "\nI have put you down for a$NAME2 at $SERVICE_TIME,$CUSTOMER_NAME."
  fi


}

HOME
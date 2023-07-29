#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if there is a working first argument
if [[ -z $1 ]]
# If not, ask for one
then echo Please provide an element as an argument.
else 
# Check if atomic data is a number
if [[ $1 = [0-9] ]]
then ATOMIC_NUMBER=$1
else ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE (name = '$1' OR symbol = '$1')")
fi
# Check if data is found
if [[ -z $ATOMIC_NUMBER ]]

# If not, state that it isn't in the database
then echo "I could not find that element in the database."

# Output info
else 
INFORMATION=$($PSQL "SELECT name, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number = $ATOMIC_NUMBER")
echo "$INFORMATION" | while IFS="|" read ELEMENT SYMBOL ATOMIC_MASS MELTING_POINT BOILING_POINT TYPE 
do
echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
done
fi
fi

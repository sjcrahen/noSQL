#Load the data into Riak 
./lab2b/load_data.erl ./lab2b/goog.csv

#Return the entire data set
curl -vSsf -X POST http://riak:8098/mapred -H 'Content-Type: application/json' -d \
'{"inputs":"goog",
"query":[{"map":{"language":"javascript",
"name":"Riak.mapValuesJson",
"keep":true}}]}'

printf "\n\n<--- Curl command below to: 1. A map-only query for finding all days where the low is less than $450.00. --->\n"






printf "\n\n<--- Curl command below to: 2. A map-only query for finding all days where the close was lower than the open --->\n"



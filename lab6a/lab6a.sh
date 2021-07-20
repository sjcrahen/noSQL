#!/usr/bin/env bash

#Add your curl statements here
HOST="http://couchdb:5984"
curl -X PUT "$HOST/restaurants/"
curl -X POST "$HOST/restaurants/" \
	-H "Content-Type:application/json" \
	-d '{"_id":"maggies_farm","name":"Maggies Farm","food_type":["American","Pub"],"phone_number":"(978) 539-8583","website":"maggiesfarmmiddleton.com"}'
curl -X POST "$HOST/restaurants/" \
	-H "Content-Type:application/json" \
	-d '{"_id":"daryas_cafe","name":"Daryas Cafe","food_type":["Diner","Breakfast"],"phone_number":"(978) 774-2739","website":"daryascafe.com"}'
curl -X POST "$HOST/restaurants/" \
	-H "Content-Type:application/json" \
	-d '{"_id":"larosas","name":"LaRosas","food_type":["Italian","Cafe"],"phone_number":"(978) 475-1777","website":"larosasofandover.com"}'

#DO NOT REMOVE
curl -Ssf -X PUT http://couchdb:5984/restaurants/_design/docs -H "Content-Type: application/json" -d '{"views": {"all": {"map": "function(doc) {emit(doc._id, {rev:doc._rev, name:doc.name, food_type:doc.food_type, phonenumber:doc.phonenumber, website:doc.website})}"}}}'
curl -Ssf -X GET http://couchdb:5984/restaurants/_design/docs/_view/all

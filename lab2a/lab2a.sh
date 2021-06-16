curl -v -X PUT http://riak:8098/riak/movies/TheShawshankRedemption \
	-H "Content-Type: application/json" \
	-d '{"releasedate":"1994","runningtime":"2:22","genre":"drama"}'

curl -v -X PUT http://riak:8098/riak/movies/TheGodfather \
	-H "Content-Type: application/json" \
	-d '{"releasedate":"1972","runningtime":"2:55","genre":"drama"}'

curl -v -X PUT http://riak:8098/riak/movies/TheDarkKnight \
	-H "Content-Type: application/json" \
	-d '{"releasedate":"2008","runningtime":"2:32","genre":"drama"}'

curl -v -X PUT http://riak:8098/riak/movies/FindingNemo \
	-H "Content-Type: application/json" \
	-d '{"releasedate":"2003","runningtime":"1:40","genre":"comedy"}'

curl -v -X PUT http://riak:8098/riak/movies/Up \
	-H "Content-Type: application/json" \
	-d '{"releasedate":"2009","runningtime":"1:36","genre":"comedy"}'

curl -v -X PUT http://riak:8098/riak/movies/WorldWarZ \
	-H "Content-Type: application/json" \
	-d '{"releasedate":"2013","runningtime":"1:56","genre":"horror"}'

curl -i -X DELETE http://riak:8098/riak/movies/TheGodfather

curl -X PUT http://riak:8098/riak/branches/East \
	-H "Content-Type: application/json" \
	-H "Link:</riak/movies/TheShawshankRedemption>; riaktag=\"has\", </riak/movies/TheDarkKnight>; riaktag=\"has\"" \
	-d '{"branch":"East"}'

curl -X PUT http://riak:8098/riak/branches/West \
	-H "Content-Type: application/json" \
	-H "Link:</riak/movies/FindingNemo>; riaktag=\"has\", </riak/movies/Up>; riaktag=\"has\",</riak/movies/WorldWarZ>; riaktag=\"has\"" \
	-d '{"branch":"West"}'

curl -X PUT http://riak:8098/riak/branches/South \
	-H "Content-Type: application/json" \
	-H "Link:</riak/movies/TheShawshankRedemption>; riaktag=\"has\", </riak/movies/Up>; riaktag=\"has\", </riak/movies/WorldWarZ>; riaktag-\"has\"" \
	-d '{"branch":"South"}'

curl -X PUT http://riak:8098/riak/images/thedarkknight.jpg \
	-H "Content-Type: image/jpeg" \
	-H "Link:</riak/movies/TheDarkKnight>; riaktag=\"image\"" \
	--data-binary @thedarkknight.jpg

curl -X GET http://riak:8098/riak?buckets=true

curl http://riak:8098/riak/branches/East/_,_,_

curl http://riak:8098/riak/branches/West/_,_,_

curl http://riak:8098/riak/branches/South/_,_,_

curl http://riak:8098/riak/images/thedarkknight.jpeg/_,_,1/_,_,_

use blogger

// 2. create 3 users with fields 'name' and 'email'
db.users.insert({_id:ObjectId("5bb26043708926e438db6cad"),name:"Bill",email:"bill@place.com"})

db.users.insert({_id:ObjectId("5bb26043708926e438db6cae"),name:"Carl",email:"carl@place.com"})

db.users.insert({_id:ObjectId("5bb26043708926e438db6caf"),name:"Dave",email:"dave@place.com"})

// 2.a list the contents of the users collection
db.users.find()

// 2.b search for user 5bb26043708926e438db6cad 
db.users.find({_id:ObjectId("5bb26043708926e438db6cad")})

// 3. create 3 blogs
function insertBlog(title, body, slug, author, comments, category) {
	db.blogs.insert({
		title:title,
		body:body,
		slug:slug,
		author:ObjectId(author),
		comments:comments,
		category:category
	});
}

insertBlog("An Interesting Blog","This blog is very interesting.","blog-1","5bb26043708926e438db6cad",[{user_id:ObjectId("5bb26043708926e438db6cae"),comment:"great point!",approved:true,created_at:ISODate("2021-06-21")},{user_id:ObjectId("5bb26043708926e438db6caf"),comment:"very interesting!!",approved:true,created_at:ISODate("2021-06-21")}],[{name:"interesting blogs"}])

insertBlog("A More Interesting Blog","This blog is more interesting, because it is discusses the framework.","blog-2","5bb26043708926e438db6cae",[{user_id:ObjectId("5bb26043708926e438db6cad"),comment:"I like it!",approved:true,created_at:ISODate("2021-06-21")},{user_id:ObjectId("5bb26043708926e438db6caf"),comment:"even more interesting!!",approved:true,created_at:ISODate("2021-06-21")}],[{name:"interesting blogs"}])

insertBlog("The Most Interesting Blog","This blog is the most interesting.","blog-3","5bb26043708926e438db6caf",[{user_id:ObjectId("5bb26043708926e438db6cae"),comment:"I am amazed!",approved:true,created_at:ISODate("2021-06-21")},{user_id:ObjectId("5bb26043708926e438db6cad"),comment:"Best, blog, ever!!",approved:true,created_at:ISODate("2021-06-21")}],[{name:"interesting blogs"}])

// 3.c get all comments by user 5bb26043708926e438db6caf
db.blogs.find({'comments.user_id':ObjectId("5bb26043708926e438db6caf")},{_id:0,title:1,slug:1})

// 4. select a blog via a case-insensitive regex containing the word Framework
db.blogs.find({body: /Framework/i},{_id:0,title:1,body:1})









'use strict';

//HTTPS
const fs = require('fs');
const https = require('https');
const privateKey  = fs.readFileSync('/etc/ssl/private/server_key.key', 'utf8');
const certificate = fs.readFileSync('/etc/ssl/private/server_cert.cer', 'utf8');
const credentials = {key: privateKey, cert: certificate};

const express = require('express');
const app = express();

const bodyParser = require('body-parser');
const mongoose = require('mongoose');
const path = require('path');
const { check, validationResult } = require('express-validator/check');

// Global Vars
app.use(function(req, res, next){
		res.locals.errors = null;
		next();
	});

//support parsing of application/json type post data
app.use(bodyParser.json());

//support parsing of application/x-www-form-urlencoded post data
app.use(bodyParser.urlencoded({ extended: true }));

const methodOverride = require('method-override');
app.use(methodOverride('_method', { methods: ['POST', 'GET'] }));
app.use(methodOverride(function (req, res) {
		if (req.body && typeof req.body === 'object' && '_method' in req.body) {
			// look in urlencoded POST bodies and delete it
			var method = req.body._method;
			delete req.body._method;
			return method;
		}
	}));

// View Engine
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

//LOGS
var morgan = require('morgan');
app.use(morgan('combined'));
var winston = require('./config/winston');
app.use(morgan('combined', { stream: winston.stream }));

//User Model
var User = require('./models/user');

//Blog Model
var Blog = require('./models/blog')

// Connect to MongoDB on VM
mongoose.connect('mongodb://10.92.130.44:27017/blogger', { useNewUrlParser: true });
const db = mongoose.connection;

// USER API ROUTES
// display
app.get('/api/users', function(req, res) {
		User.getUsers(function(err, users) {
			if(err) {
				throw err;
			}
			res.json(users);
		});
	});

// display by id
app.get('/api/users/:_id', function(req, res) {
		User.getUserById(req.params._id, function(err, user) {
			if(err) {
				throw err;
			}
			res.json(user);
		});
	});

// add
app.post('/api/users', function(req, res){
		var user = req.body;

		User.addUser(user, (err, user) => {
			if(err){
				throw err;
			}
			res.json(user);
		});
	});

// update
app.put('/api/users/:_id', function(req, res){
		var user = req.body;

		const options = {returnNewDocument:true};

		User.updateUser(req.params._id, user, options, (err, user) => {
			if(err){
				throw err;
			}
			res.json(user);
		});
	});

// delete
app.delete('/api/users/:_id', function(req, res) {
		User.removeUser(req.params._id, function(err, blog) {
			if(err){
				throw err;
			}
			res.json(blog);
		});
	});

//WEB ROUTES
// display users
app.get('/', function(req, res){
		User.getUsers(function(err, users){
			res.render('index', {users: users});
		});
	});

// display by id for edit view
app.get('/users/edit/:_id', function(req, res) {
		User.getUserById(req.params._id, function(err, user) {
			if(err){
				throw err;
			}
			res.render('edit', {user: user});
		});
	});

// delete
app.delete('/users/delete/:_id', function(req, res) {
		User.removeUser(req.params._id, function(err, user) {
			if(err){
				throw err;
			}
			res.redirect('/');
		});
	});

// add
app.post('/users/add', 
	[check('name').not().isEmpty().withMessage('Name is a required field.'),
	check('email').not().isEmpty().withMessage('Email is a required field.'),
	check('email').isEmail().withMessage('Email field is not a valid email address.')],
	function(req, res){

		const errors = validationResult(req);

		if(!errors.isEmpty()) {
			User.getUsers(function(err, users){
				res.render('index', {users: users, errors: errors.array()})
			});
		} else {
			var newUser = {
				name: req.body.name,
				email: req.body.email
			}
			User.addUser(newUser, (err, user) => {
				if(err){
					throw err;
				}
				res.redirect('/');
			});
		}
	}
);

// update
app.put('/users/edit/:_id',
	[check('name').not().isEmpty().withMessage('Name is a required field.'),
	check('email').not().isEmpty().withMessage('Email is a required field.'),
	check('email').isEmail().withMessage('Email field is not a valid email address.')],
	function(req, res){

		const errors = validationResult(req);

		var newUser = {
			_id: req.params._id,
			name: req.body.name,
			email: req.body.email
		}

		if(!errors.isEmpty()) {
			res.render('edit', {user: newUser, errors: errors.array()});
		} else {
			const options = {returnNewDocument:true};
			User.updateUser(req.params._id, newUser, options, (err, user) => {
				if(err){
					throw err;
				}
				res.redirect('/');
			});
		}
	}
);

// API routes for blogs
// display 
app.get('/api/blogs', function(req, res) {
		Blog.getBlogs(function(err, blogs) {
			if(err){
				throw err;
			}
			res.json(blogs);
		});
	});

// display by id
app.get('/api/blogs/:_id', function(req, res) {
		Blog.getBlogById(req.params._id, function(err, blog) {
			if(err){
				throw err;
			}
			res.json(blog);
		});
	});

// add
app.post('/api/blogs', function(req, res){
		var blog = req.body;

		Blog.addBlog(blog, (err, blog) => {
			if(err){
				throw err;
			}
			res.json(blog);
		});
	});

// update
app.put('/api/blogs/:_id', function(req, res){
		var blog = req.body;

		const options = {returnNewDocument:true};

		Blog.updateBlog(req.params._id, blog, options, (err, blog) => {
			if(err){
				throw err;
			}
			res.json(blog);
		});
	});

// delete
app.delete('/api/blogs/:_id', function(req, res) {
		Blog.removeBlog(req.params._id, function(err, blog) {
			if(err){
				throw err;
			}
			res.json(blog);
		});
	});

//WEB ROUTES
// display
app.get('/blogs', function(req, res){
		
	User.getUsers(function(err, users) {
		Blog.getBlogs(function(err, blogs){
			res.render('blogs', {blogs: blogs, users:users})
		});
	});
});

// display by id for edit
app.get('/blogs/edit/:_id', function(req, res) {
	User.getUsers(function(err, users) {
		Blog.getBlogById(req.params._id, function(err, blog) {
			if(err){
				throw err;
			}
			res.render('editBlog', {blog: blog, users:users});
		});
	});
});


// delete
app.delete('/blogs/delete/:_id', function(req, res) {
		Blog.removeBlog(req.params._id, function(err, blog) {
			if(err){
				throw err;
			}
			res.redirect('/blogs');
			});
	});

// add
app.post('/blogs/add',
	[check('title').not().isEmpty().withMessage('Title is a required field.'),
	check('slug').not().isEmpty().withMessage('Slug is a required field.'),
	check('body').not().isEmpty().withMessage('Body is a required field.'),
	check('comments').not().isEmpty().withMessage('Comments is a required field.'),
	check('category').not().isEmpty().withMessage('Category is a required field.')],
	function(req, res){

		const errors = validationResult(req);

		if(!errors.isEmpty()) {
			User.getUsers(function(err, users) {
				Blog.getBlogs(function(err, blogs){
					res.render('blogs', {blogs: blogs,errors: errors.array(), users: users});
				});
			});
		} else {
			var newBlog = new Blog({
				title: req.body.title,
				slug: req.body.slug,
				author: req.body.author,
				body: req.body.body,
				comments: {
					user_id: req.body.author,
					comment: req.body.comments},
				category: {
					name: req.body.category}
			});

			Blog.addBlog(newBlog, (err, blog) => {
				if(err){
					throw err;
				}
				res.redirect('/blogs');
			});
		}
	}
);

// update
app.put('/blogs/edit/:_id',
	[check('title').not().isEmpty().withMessage('Title is a required field.'),
	check('slug').not().isEmpty().withMessage('Slug is a required field.'),
	check('body').not().isEmpty().withMessage('Body is a required field.')],
	function(req, res){

		const errors = validationResult(req);

		let newComments = [];
		for (let i=0; i<req.body.comments.length; i++) {
			newComments[i] = "{user_id:" + req.body.comments[i].user_id + ", comment:" + req.body.comments[i].comment + "}";
		}

		let newCategories = [];
		for (let i=0; i<req.body.category.length; i++) {
			newCategories[i] = "{name:" + req.body.category[i].name + "}";
		}

		var newBlog = new Blog({
			_id: req.params._id,
			title: req.body.title,
			slug: req.body.slug,
			author: req.body.author,
			body: req.body.body,
			comments: req.body.comments,
			category: req.body.category
		});
	
		if(!errors.isEmpty()) {
			User.getUsers(function(err, users) {
				Blog.getBlogById(req.params._id, function(err, blog) {
					res.render('editBlog', {blog: blog,	errors: errors.array(), users: users});
				});
			});
		} else {
			const options = {returnNewDocument:true};
				Blog.updateBlog(req.params._id, newBlog, options, (err, blog) => {
					if(err){
						throw err;
					}
					res.redirect('/blogs');
				});
		}
	}
);

const httpsServer = https.createServer(credentials, app);
httpsServer.listen(8443);
console.log('Running on port 8443...');

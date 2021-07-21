const mongoose = require('mongoose');

// comments schema
const commentSchema = mongoose.Schema({
    user_id:{
        type: mongoose.Schema.Types.ObjectId,
        required: true
    },
    comment:{
        type: String,
        required: true
    },
    approved: {
        type: Boolean,
        default: false
    },
    created_at:{
        type: Date,
        default: Date.now
    }
});

// category schema
const categorySchema = mongoose.Schema({
    name:{
        type: String,
        required: true
    } 
});

// Blog Schema
const blogSchema = mongoose.Schema({
	title:{
        type: String,
        required: true
    },
    body:{
        type: String,
        required: true
    },
	slug:{
        type: String,
        required: true
    },
    author: {type: mongoose.Schema.Types.ObjectId, ref: 'User'},
    comments: commentSchema,
    category: categorySchema
});

const Blog = module.exports = mongoose.model('Blog', blogSchema);

// Get All Blogs - find method
module.exports.getBlogs = (callback, limit) => {
	Blog.find(callback).populate('author').limit(limit);
}

// Get Blog - findById method
module.exports.getBlogById = (id, callback) => {
	Blog.findById(id, callback).populate('author');
}

// Add Blog - create method
module.exports.addBlog = (blog, callback) => {
	Blog.create(blog, callback);
}

// Update Blog - findOneAndUpdate method
module.exports.updateBlog =(id, blog, options, callback) => {
	Blog.findOneAndUpdate({_id:id}, blog, options, callback).populate('author');
} 

// Delete Blog - deleteOne method
module.exports.removeBlog = (id, callback) => {
	Blog.deleteOne({_id:id}, callback);
}
var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var User = new Schema({
    username         : {type: String, required: true, index: { unique: true }},
    first_name       : {type: String, required: false},
    last_name        : {type: String, required: false},
    email            : {type: String, required: false},
    password         : {type: String, required: true},
    is_superuser     : {type: Boolean, required: true},
	// Might be better to use json stringify for now
	// FIXME : This is just a hack to get it working for now
	token            : String
});

module.exports = mongoose.model('user', User);
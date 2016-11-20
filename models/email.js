var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var email = new Schema({
    email       : String
});

module.exports = mongoose.model('email', email);
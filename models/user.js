var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var User = new Schema({
    name        : {type: String, required: false},
    email       : {type: String, required: true}
});

module.exports = mongoose.model('user', User);
var mongoose = require('mongoose');
var config = require("../config/db");

var cmsSchema = mongoose.Schema({
    pagename:String,
    pageheading:String,
    content:String
});

module.exports = mongoose.model('cmses', cmsSchema);


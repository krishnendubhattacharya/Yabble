var mongoose = require('mongoose');
var config = require("../config/db");
var appyabcommentsSchema = mongoose.Schema({
	user_id:String,
	yab_id:String,
	comment:String,
	post_date:String
});

module.exports = mongoose.model('appyabcomments', appyabcommentsSchema);
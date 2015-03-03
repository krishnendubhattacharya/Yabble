var mongoose = require('mongoose');

var userprofileSchema = mongoose.Schema({	
	UserID:String,
	ack:String,
	totalyabs:String,
	name:String,
	bio:String,
	username:String,
	img:String
});
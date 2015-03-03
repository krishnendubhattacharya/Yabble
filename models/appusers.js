var mongoose = require('mongoose');

var app_userSchema = mongoose.Schema({	
	LastID:String,
	ack:String,
	userdetail:String,
	msg:String,
});
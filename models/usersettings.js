var mongoose = require('mongoose');

var usrsettingsSchema = mongoose.Schema({	
	LastID:String,
	ack:String,
	SettingDetails:String,
	msg:String,
});
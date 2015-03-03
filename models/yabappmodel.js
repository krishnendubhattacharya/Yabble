var mongoose = require('mongoose');
var config = require("../config/db");
var yabappsSchema = mongoose.Schema({
	user_id:String,
	business_id:String,
	message:String,
	user_ip:String,
	latitude:String,
	longitude:String,
	min_age:String,
	max_age:String,
	yab_for:String,
	yab_send_to:String,
	push_notification:String,
	broadcast_radius:String,
	image:String,
	imagewidth:String,
	imageheight:String,
	expiration_date:String,
	post_date:String,
	yab_from:String,
	total_comment:Number,
	total_like:Number
});

module.exports = mongoose.model('yabapps', yabappsSchema);

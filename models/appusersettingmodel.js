var mongoose=require('mongoose');
var config=require("../config/db");
var UserSettingSchema=mongoose.Schema({
	user_id:String,
	yabreach:String,
	is_show_address:String
});
module.exports=mongoose.model('appusersettings',UserSettingSchema);
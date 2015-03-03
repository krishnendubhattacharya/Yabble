var mongoose = require('mongoose');
var config = require("../config/db");

var businessSchema = mongoose.Schema({
    name: String,
    username: String,
    bio:String,
    image:String,
    facebook:String,
    twitter:String,
    instagram:String,
    registration_date:String,
    is_active:Number,
    yabperweek:Number,
    yabpermonth:Number,
    yabperyear:Number,
    userperaccount:Number,
    is_push:Number,
    is_send_all:Number,
    is_search_zip:Number,
    total_member:Number
});
module.exports = mongoose.model('businessprofiles', businessSchema);

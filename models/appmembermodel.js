var mongoose = require('mongoose');
var config = require("../config/db");

var appmemberSchema = mongoose.Schema({
    name:String,
    username:String,
    email:String,
    bio:String,
    gender:String,
    dob:String,
    facebook:String,
    twitter:String,
    instagram:String,
    latitude:String,
    longitude:String,
    registration_date:String,
    is_active:Number,
    device_token:String,
    is_logged_in:String,
    last_logged_in:String,
    password:String,
    image:String
});

module.exports = mongoose.model('membersapps', appmemberSchema);


var mongoose = require('mongoose');
var config = require("../config/db");
var adminSchema = mongoose.Schema({
    first_name: String,
    last_name:String,
    email:String,
    password:String,
    phone:String,
    paypal_email:String,
    latitude:String,
    longitude:String
});
module.exports = mongoose.model('admins', adminSchema);

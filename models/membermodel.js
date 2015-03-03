var mongoose = require('mongoose');
var config = require("../config/db");

var memberSchema = mongoose.Schema({
    business_id:String,
    name:String,
    email:String,
    password:String,
    is_business_admin:Number,
    dob:String,
    latitude:String,
    longitude:String,
    registration_date:String,
    is_active:Number
});

module.exports = mongoose.model('members', memberSchema);


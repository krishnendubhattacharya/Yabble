var mongoose = require('mongoose');
var config = require("../config/db");

var appyablikesSchema = mongoose.Schema({
user_id:String,
yab_id:String,
yab_status:String

});
module.exports = mongoose.model('appyablikes', appyablikesSchema);

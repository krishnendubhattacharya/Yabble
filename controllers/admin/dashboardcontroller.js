var http = require("http");
var express = require('express');
var mongoose = require('mongoose');
var Appmember = require('../../models/appmembermodel');
var router = express.Router();
var session = require('express-session');
var md5 = require('MD5');
var html = require('html');
var _host='108.179.225.244';
var _port='3000';

/*Dashboard*/
router.get('/', function(req, res) {
    if(req.session.user==null || req.session.user=='')
    {
     res.redirect("/admin");
    }
    else
    {
      var username=req.session.user.first_name;
      res.render('admin/dashboard', { 'uname': username});
    }
});

module.exports = router;

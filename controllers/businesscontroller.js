var http = require("http");
var express = require('express');
var mongoose = require('mongoose');
var Member = require('../models/membermodel');
var Business = require('../models/businessmodel');
var router = express.Router();
var session = require('express-session');
var md5 = require('MD5');
var html = require('html');
var moment = require('moment');
var _host='108.179.225.244';
var _port='3000';



router.get('/edit', function(req, res) {
    if(req.session.user==null || req.session.user=='')
    {
     res.redirect("/");
    }
    else
    {
     var username=req.session.user.name;
     var is_business_admin=req.session.user.is_business_admin;
     var business_id=req.session.user.business_id;
     var options = {host:_host,port:_port,path:'/api/business/edit/'+business_id};
      http.get(options, function (http_res) {
             var data = "";
             http_res.on("data", function (chunk) {
                 data += chunk;
             }).on("end", function () {
                 if(data=='error')
                 {
                   res.redirect("/");
                 }
                 else
                 {
                   businessfind = JSON.parse(data);
                   res.render('business-edit',{'uname' : username,'is_business_admin':is_business_admin,'businessfind':businessfind});
                 }
             }).on('error', function(e){
             console.log(e);
             res.redirect("/");
           });
      }).on('error', function(e){
             console.log(e);
             res.redirect("/");
      });
    }
});


module.exports = router;

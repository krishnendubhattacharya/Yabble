var http = require("http");
var express = require('express');
var mongoose = require('mongoose');
var Member = require('../models/membermodel');
var router = express.Router();
var session = require('express-session');
var md5 = require('MD5');
var html = require('html');
var _host='108.179.225.244';
var _port='3000';


router.get('/', function(req, res, next) {
    res.render('index', { title: 'Express' });
});


router.post('/login', function(req, res) {
    var _email = req.body.username;
    var _password = req.body.password; 
    var _ulatitude = req.body.ulatitude;
    var _ulongitude = req.body.ulongitude;
    
    var options = {host:_host,port:_port,path:'/api/member/login/'+_email+'/'+_password+'/'+_ulatitude+'/'+_ulongitude};
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
           req.session.user = JSON.parse(data);
           res.redirect("/editprofile");
         }
     }).on('error', function(e){
             console.log(e);
             res.redirect("/");
      });
   }).on('error', function(e){
             console.log(e);
             res.redirect("/");
   });
});


router.get('/logout', function(req, res) {
    req.session.user = null;
    res.redirect("/");
});


router.get('/editprofile', function(req, res) {
    if(req.session.user==null || req.session.user=='')
    {
     res.redirect("/");
    }
    else
    {
     var email=req.session.user.email;
     var username=req.session.user.name;
     var is_business_admin=req.session.user.is_business_admin;
     var userid=req.session.user._id;
     res.render('editprofile',{ 'uname': username,'userid':userid,'is_business_admin':is_business_admin,'email':email});
    }
});

router.get('/changepassword', function(req, res) {
    if(req.session.user==null || req.session.user=='')
    {
     res.redirect("/");
    }
    else
    {
     var username=req.session.user.name;
     var is_business_admin=req.session.user.is_business_admin;
     var userid=req.session.user._id;
     res.render('changepassword',{ 'uname': username,'userid':userid,'is_business_admin':is_business_admin});
    }
});


module.exports = router;

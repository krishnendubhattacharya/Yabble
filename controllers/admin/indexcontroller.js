var http = require("http");
var express = require('express');
var mongoose = require('mongoose');
var Admin = require('../../models/adminmodel');
var router = express.Router();
var session = require('express-session');
var md5 = require('MD5');
var html = require('html');
var _host='108.179.225.244';
var _port='3000';

/* Admin Home Page */
router.get('/', function(req, res, next) {
    res.render('admin/index', { title: 'Express' });
});

/* Admin Login */
router.post('/login', function(req, res) {
    var _email = req.body.username;
    var _password = req.body.password; 
    var _ulatitude = req.body.ulatitude;
    var _ulongitude = req.body.ulongitude;
    
    var options = {host:_host,port:_port,path:'/api/admin/login/'+_email+'/'+_password+'/'+_ulatitude+'/'+_ulongitude};
    http.get(options, function (http_res) {
     var data = "";
     http_res.on("data", function (chunk) {
         data += chunk;
     }).on("end", function () {
         if(data=='error')
         {
           res.redirect("/admin");
         }
         else
         {
           req.session.user = JSON.parse(data);
           res.redirect("/admin/editprofile");
         }
     }).on('error', function(e){
             console.log(e);
             res.redirect("/admin");
      });
   }).on('error', function(e){
             console.log(e);
             res.redirect("/admin");
   });
});

/* Admin Logout */
router.get('/logout', function(req, res) {
    req.session.user = null;
    res.redirect("/admin");
});

/* Admin Edit Profile*/
router.get('/editprofile', function(req, res) {
    if(req.session.user==null || req.session.user=='')
    {
     res.redirect("/admin");
    }
    else
    {
     var email=req.session.user.email;
     var uid=req.session.user._id;
     var username=req.session.user.first_name;
     var options = {host:_host,port:_port,path:'/api/admin/editprofile/'+uid};
     http.get(options, function (http_res) {
      var data = "";
      http_res.on("data", function (chunk) {
         data += chunk;
      }).on("end", function () {
         if(data=='error')
         {
           res.redirect("/admin");
         }
         else
         {
           user = JSON.parse(data);
           res.render('admin/admin-edit',{ 'uname': username,'user':user});
         }
       }).on('error', function(e){
             console.log(e);
             res.redirect("/admin");
       });
     }).on('error', function(e){
             console.log(e);
             res.redirect("/admin");
     });
    }
});


module.exports = router;

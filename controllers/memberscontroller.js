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


/* Member List Page */
router.get('/', function(req, res) {
    if(req.session.user==null || req.session.user=='')
    {
     res.redirect("/");
    }
    else
    {
     var username=req.session.user.name;
     var is_business_admin=req.session.user.is_business_admin;
     var business_id=req.session.user.business_id;
     var id=req.session.user._id;
     var options = {host:_host,port:_port,path:'/api/member/mymembers/'+business_id+'/'+id};
      http.get(options, function (http_res) {
             var data = "";
             http_res.on("data", function (chunk) {
                 data += chunk;
             }).on("end", function () {
                 if(data)
                 {
                   memberdata = JSON.parse(data);
                   res.render('members', { 'uname': username,'is_business_admin':is_business_admin,'member_exist':memberdata[0],'all_members':memberdata[1],'all_businesses':memberdata[2]});
                 }
             }).on('error', function(e){
             console.log(e);
             res.redirect("/members");
            });
       }).on('error', function(e){
             console.log(e);
             res.redirect("/members");
      });
    }
});

/*Member Add*/
router.get('/add', function(req, res) {
  var all_businesses=[];
  if(req.session.user==null || req.session.user=='')
  {
     res.redirect("/");
  }
  else
  {
       var username=req.session.user.name;
       var is_business_admin=req.session.user.is_business_admin;
       var business_id=req.session.user.business_id;
       Business.find({'_id':business_id,'is_active':1},function(err,businesses){
        if(businesses)
        {
           for(var b in businesses)
           {
            var businessdetail;
            businessdetail = ({ "id": businesses[b]._id,'name': businesses[b].username});
            all_businesses.push(businessdetail);
           }
        }
        else
        {
        }
        res.render('member-add', { 'uname': username,'is_business_admin':is_business_admin,'all_businesses':all_businesses});
     });
  }
});


router.get('/view/:id', function(req, res) {
  var id = req.params.id;
  if(req.session.user==null || req.session.user=='')
  {
     res.redirect("/");
  }
  else
  {
      var username=req.session.user.name;
      var is_business_admin=req.session.user.is_business_admin;
      var options = {host:_host,port:_port,path:'/api/member/view/'+id};
      http.get(options, function (http_res) {
             var data = "";
             http_res.on("data", function (chunk) {
                 data += chunk;
             }).on("end", function () {
                 if(data=='error')
                 {
                   res.redirect("/members");
                 }
                 else
                 {
                   memberdata = JSON.parse(data);
                   res.render('member-view', { 'uname': username,'is_business_admin':is_business_admin,'memberview':memberdata[0] ,'business':memberdata[1]});
                 }
             }).on('error', function(e){
             console.log(e);
             res.redirect("/members");
            });
      }).on('error', function(e){
             console.log(e);
             res.redirect("/members");
      });
  }
});


router.get('/edit/:id', function(req, res) {
    var id = req.params.id;
    if(req.session.user==null || req.session.user=='')
    {
     res.redirect("/");
    }
    else
    {
     var username=req.session.user.name;
     var business_id=req.session.user.business_id;
     var is_business_admin=req.session.user.is_business_admin;
     var options = {host:_host,port:_port,path:'/api/member/memberedit/'+id+'/'+business_id};
      http.get(options, function (http_res) {
             var data = "";
             http_res.on("data", function (chunk) {
                 data += chunk;
             }).on("end", function () {
                 if(data=='error')
                 {
                   res.redirect("/members");
                 }
                 else
                 {
                   memberdata = JSON.parse(data);
                   res.render('member-edit', { 'uname': username,'is_business_admin':is_business_admin,'memberfind':memberdata[0],'all_businesses':memberdata[1]});
                 }
             }).on('error', function(e){
             console.log(e);
             res.redirect("/members");
            });
      }).on('error', function(e){
             console.log(e);
             res.redirect("/members");
      });
    }
});


module.exports = router;

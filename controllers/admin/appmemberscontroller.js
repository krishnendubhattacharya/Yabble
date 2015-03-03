var http = require("http");
var express = require('express');
var mongoose = require('mongoose');
var AppMember = require('../../models/appmembermodel');
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
     res.redirect("/admin");
    }
    else
    {
     var username=req.session.user.first_name;
     var options = {host:_host,port:_port,path:'/api/appmember/'};
      http.get(options, function (http_res) {
             var data = "";
             http_res.on("data", function (chunk) {
                 data += chunk;
             }).on("end", function () {
                 if(data)
                 {
                   memberdata = JSON.parse(data);
                   res.render('admin/appmembers', { 'uname': username,'member_exist':memberdata[0],'all_members':memberdata[1]});
                 }
             }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/appmembers");
            });
       }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/appmembers");
      });
    }
});

router.get('/delete/:id', function(req, res) {
    var id = req.params.id;
    if(req.session.user==null || req.session.user=='')
    {
     res.redirect("/admin");
    }
    else
    {
     var options = {host:_host,port:_port,path:'/api/appmember/delete/'+id};
      http.get(options, function (http_res) {
             var data = "";
             http_res.on("data", function (chunk) {
                 data += chunk;
             }).on("end", function () {
                 if(data=='error')
                 {
                   res.redirect("/admin/appmembers");
                 }
                 else
                 {
                   res.redirect("/admin/appmembers");
                 }
             }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/appmembers");
            });
       }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/appmembers");
      });
    }
});

router.get('/active/:id', function(req, res) {
    var id = req.params.id;
    if(req.session.user==null || req.session.user=='')
    {
     res.redirect("/admin");
    }
    else
    {
      var options = {host:_host,port:_port,path:'/api/appmember/active/'+id};
      http.get(options, function (http_res) {
             var data = "";
             http_res.on("data", function (chunk) {
                 data += chunk;
             }).on("end", function () {
                 if(data=='error')
                 {
                   res.redirect("/admin/appmembers");
                 }
                 else
                 {
                   res.redirect("/admin/appmembers");
                 }
             }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/appmembers");
            });
       }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/appmembers");
      });
    }
});

router.get('/deactive/:id', function(req, res) {
    var id = req.params.id;
    if(req.session.user==null || req.session.user=='')
    {
     res.redirect("/admin");
    }
    else
    {
     var options = {host:_host,port:_port,path:'/api/appmember/deactive/'+id};
      http.get(options, function (http_res) {
             var data = "";
             http_res.on("data", function (chunk) {
                 data += chunk;
             }).on("end", function () {
                 if(data=='error')
                 {
                   res.redirect("/admin/appmembers");
                 }
                 else
                 {
                   res.redirect("/admin/appmembers");
                 }
             }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/appmembers");
            });
       }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/appmembers");
      });
    }
});

router.get('/view/:id', function(req, res) {
  var id = req.params.id;
  if(req.session.user==null || req.session.user=='')
  {
     res.redirect("/admin");
  }
  else
  {
      var username=req.session.user.first_name;
      var options = {host:_host,port:_port,path:'/api/appmember/view/'+id};
      http.get(options, function (http_res) {
             var data = "";
             http_res.on("data", function (chunk) {
                 data += chunk;
             }).on("end", function () {
                 if(data=='error')
                 {
                   res.redirect("/admin/appmembers");
                 }
                 else
                 {
                   memberdata = JSON.parse(data);
                   res.render('admin/appmember-view', { 'uname': username,'memberview':memberdata[0]});
                 }
             }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/appmembers");
            });
      }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/appmembers");
      });
  }
});

router.get('/edit/:id', function(req, res) {
    var id = req.params.id;
    if(req.session.user==null || req.session.user=='')
    {
     res.redirect("/admin");
    }
    else
    {
     var username=req.session.user.first_name;
     var options = {host:_host,port:_port,path:'/api/appmember/edit/'+id};
      http.get(options, function (http_res) {
             var data = "";
             http_res.on("data", function (chunk) {
                 data += chunk;
             }).on("end", function () {
                 if(data=='error')
                 {
                   res.redirect("/admin/appmembers");
                 }
                 else
                 {
                   memberdata = JSON.parse(data);
                   res.render('admin/appmember-edit', { 'uname': username,'memberfind':memberdata[0]});
                 }
             }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/appmembers");
            });
      }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/appmembers");
      });
    }
});


module.exports = router;

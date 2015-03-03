var http = require("http");
var express = require('express');
var mongoose = require('mongoose');
var Member = require('../../models/membermodel');
var Business = require('../../models/businessmodel');
var router = express.Router();
var session = require('express-session');
var md5 = require('MD5');
var html = require('html');
var moment = require('moment');
var _host='108.179.225.244';
var _port='3000';

/* Business List Page */
router.get('/', function(req, res) {
    if(req.session.user==null || req.session.user=='')
    {
     res.redirect("/admin");
    }
    else
    {
      var username=req.session.user.first_name;
      var options = {host:_host,port:_port,path:'/api/business/'};
      http.get(options, function (http_res) {
             var data = "";
             http_res.on("data", function (chunk) {
                 data += chunk;
             }).on("end", function () {
                 if(data)
                 {
                   businessdata = JSON.parse(data);
                   res.render('admin/business', { 'uname': username,'business_exist':businessdata[0] ,'all_businesses':businessdata[1]});
                 }
             }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/business");
            });
       }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/business");
      });
    }
});

/*Business Add*/
router.get('/add', function(req, res) {
  if(req.session.user==null || req.session.user=='')
  {
     res.redirect("/admin");
  }
  else
  {
       var username=req.session.user.first_name;
       res.render('admin/business-add', { 'uname': username});
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
      var options = {host:_host,port:_port,path:'/api/business/delete/'+id};
      http.get(options, function (http_res) {
             var data = "";
             http_res.on("data", function (chunk) {
                 data += chunk;
             }).on("end", function () {
                 if(data=='error')
                 {
                   res.redirect("/admin/business");
                 }
                 else
                 {
                   res.redirect("/admin/business");
                 }
            }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/business");
           });
      }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/business");
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
      var options = {host:_host,port:_port,path:'/api/business/active/'+id};
      http.get(options, function (http_res) {
             var data = "";
             http_res.on("data", function (chunk) {
                 data += chunk;
             }).on("end", function () {
                 if(data=='error')
                 {
                   res.redirect("/admin/business");
                 }
                 else
                 {
                   res.redirect("/admin/business");
                 }
            }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/business");
           });
      }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/business");
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
     var options = {host:_host,port:_port,path:'/api/business/deactive/'+id};
      http.get(options, function (http_res) {
             var data = "";
             http_res.on("data", function (chunk) {
                 data += chunk;
             }).on("end", function () {
                 if(data=='error')
                 {
                   res.redirect("/admin/business");
                 }
                 else
                 {
                   res.redirect("/admin/business");
                 }
            }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/business");
           });
      }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/business");
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
      var options = {host:_host,port:_port,path:'/api/business/view/'+id};
      http.get(options, function (http_res) {
             var data = "";
             http_res.on("data", function (chunk) {
                 data += chunk;
             }).on("end", function () {
                 if(data=='error')
                 {
                   res.redirect("/admin/business");
                 }
                 else
                 {
                   businessview = JSON.parse(data);
                   res.render('admin/business-view',{'uname' : username,'businessview':businessview});
                 }
             }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/business");
            });
      }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/business");
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
     var options = {host:_host,port:_port,path:'/api/business/edit/'+id};
      http.get(options, function (http_res) {
             var data = "";
             http_res.on("data", function (chunk) {
                 data += chunk;
             }).on("end", function () {
                 if(data=='error')
                 {
                   res.redirect("/admin/business");
                 }
                 else
                 {
                   businessfind = JSON.parse(data);
                   res.render('admin/business-edit',{'uname' : username,'businessfind':businessfind});
                 }
             }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/business");
           });
      }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/business");
      });
    }
});


module.exports = router;

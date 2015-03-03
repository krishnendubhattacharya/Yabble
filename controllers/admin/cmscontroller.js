var http = require("http");
var express = require('express');
var mongoose = require('mongoose');
var Cms = require('../../models/cmsmodel');
var router = express.Router();
var session = require('express-session');
var md5 = require('MD5');
var html = require('html');
var _host='108.179.225.244';
var _port='3000';

/*CMS List*/
router.get('/', function(req, res) {
    if(req.session.user==null || req.session.user=='')
    {
     res.redirect("/admin");
    }
    else
    {
      var username=req.session.user.first_name;
      var options = {host:_host,port:_port,path:'/api/cms/'};
      http.get(options, function (http_res) {
             var data = "";
             http_res.on("data", function (chunk) {
                 data += chunk;
             }).on("end", function () {
                 if(data)
                 {
                   cmsdata = JSON.parse(data);
                   res.render('admin/cms', { 'uname': username,'cms_exist':cmsdata[0] ,'all_cms':cmsdata[1]});
                 }
             }).on('error', function(e){
               console.log(e);
               res.redirect("/admin/cms");
            });
       }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/cms");
       });
    }
});

/*CMS Add*/
router.get('/add', function(req, res) {
  if(req.session.user==null || req.session.user=='')
  {
     res.redirect("/admin");
  }
  else
  {
    var username=req.session.user.first_name;
    res.render('admin/cms-add', { 'uname': username});
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
      var options = {host:_host,port:_port,path:'/api/cms/view/'+id};
      http.get(options, function (http_res) {
             var data = "";
             http_res.on("data", function (chunk) {
                 data += chunk;
             }).on("end", function () {
                 if(data=='error')
                 {
                   res.redirect("/admin/cms");
                 }
                 else
                 {
                   cmsdata = JSON.parse(data);
                   res.render('admin/cms-view',{'uname' : username,'cms':cmsdata});
                 }
             }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/cms");
            });
      }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/cms");
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
     var options = {host:_host,port:_port,path:'/api/cms/edit/'+id};
     http.get(options, function (http_res) {
      var data = "";
      http_res.on("data", function (chunk) {
         data += chunk;
      }).on("end", function () {
         if(data=='error')
         {
           res.redirect("/admin/cms");
         }
         else
         {
           cms = JSON.parse(data);
           res.render('admin/cms-edit',{ 'uname': username,'cms':cms});
         }
       }).on('error', function(e){
          console.log(e);
          res.redirect("/admin/cms");
       });
     }).on('error', function(e){
          console.log(e);
          res.redirect("/admin/cms");
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
      var options = {host:_host,port:_port,path:'/api/cms/delete/'+id};
      http.get(options, function (http_res) {
             var data = "";
             http_res.on("data", function (chunk) {
                 data += chunk;
             }).on("end", function () {
                 if(data=='error')
                 {
                   res.redirect("/admin/cms");
                 }
                 else
                 {
                   res.redirect("/admin/cms");
                 }
            }).on('error', function(e){
                      console.log(e);
                      res.redirect("/admin/cms");
           });
      }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/cms");
      });
    }
});

module.exports = router;

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


/* Member List Page */
router.get('/', function(req, res) {
    if(req.session.user==null || req.session.user=='')
    {
     res.redirect("/admin");
    }
    else
    {
     var username=req.session.user.first_name;
     var options = {host:_host,port:_port,path:'/api/member/'};
      http.get(options, function (http_res) {
             var data = "";
             http_res.on("data", function (chunk) {
                 data += chunk;
             }).on("end", function () {
                 if(data)
                 {
                   memberdata = JSON.parse(data);
                   res.render('admin/members', { 'uname': username,'member_exist':memberdata[0],'all_members':memberdata[1],'all_businesses':memberdata[2]});
                 }
             }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/members");
            });
       }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/members");
      });
    }
});

/*Member Add*/
router.get('/add', function(req, res) {
  var all_businesses=[];
  if(req.session.user==null || req.session.user=='')
  {
     res.redirect("/admin");
  }
  else
  {
       var username=req.session.user.first_name;
       Business.find({'is_active':1},function(err,businesses){
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
        res.render('admin/member-add', { 'uname': username,'all_businesses':all_businesses});
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
      var options = {host:_host,port:_port,path:'/api/member/delete/'+id};
      http.get(options, function (http_res) {
             var data = "";
             http_res.on("data", function (chunk) {
                 data += chunk;
             }).on("end", function () {
                 if(data=='error')
                 {
                   res.redirect("/admin/members");
                 }
                 else
                 {
                   res.redirect("/admin/members");
                 }
            }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/members");
           });
      }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/members");
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
     var options = {host:_host,port:_port,path:'/api/member/active/'+id};
      http.get(options, function (http_res) {
             var data = "";
             http_res.on("data", function (chunk) {
                 data += chunk;
             }).on("end", function () {
                 if(data=='error')
                 {
                   res.redirect("/admin/members");
                 }
                 else
                 {
                   res.redirect("/admin/members");
                 }
            }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/members");
           });
      }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/members");
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
     var options = {host:_host,port:_port,path:'/api/member/deactive/'+id};
      http.get(options, function (http_res) {
             var data = "";
             http_res.on("data", function (chunk) {
                 data += chunk;
             }).on("end", function () {
                 if(data=='error')
                 {
                   res.redirect("/admin/members");
                 }
                 else
                 {
                   res.redirect("/admin/members");
                 }
            }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/members");
           });
      }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/members");
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
      var options = {host:_host,port:_port,path:'/api/member/view/'+id};
      http.get(options, function (http_res) {
             var data = "";
             http_res.on("data", function (chunk) {
                 data += chunk;
             }).on("end", function () {
                 if(data=='error')
                 {
                   res.redirect("/admin/members");
                 }
                 else
                 {
                   memberdata = JSON.parse(data);
                   res.render('admin/member-view', { 'uname': username,'memberview':memberdata[0] ,'business':memberdata[1]});
                 }
             }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/members");
            });
      }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/members");
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
     var options = {host:_host,port:_port,path:'/api/member/edit/'+id};
      http.get(options, function (http_res) {
             var data = "";
             http_res.on("data", function (chunk) {
                 data += chunk;
             }).on("end", function () {
                 if(data=='error')
                 {
                   res.redirect("/admin/members");
                 }
                 else
                 {
                   memberdata = JSON.parse(data);
                   res.render('admin/member-edit', { 'uname': username,'memberfind':memberdata[0],'all_businesses':memberdata[1]});
                 }
             }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/members");
            });
      }).on('error', function(e){
             console.log(e);
             res.redirect("/admin/members");
      });
    }
});


module.exports = router;

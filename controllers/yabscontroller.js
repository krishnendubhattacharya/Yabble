var http = require("http");
var express = require('express');
var mongoose = require('mongoose');
var Yab = require('../models/yabappmodel');
var Business = require('../models/businessmodel');
var router = express.Router();
var session = require('express-session');
var md5 = require('MD5');
var html = require('html');
var moment = require('moment');
var _host='108.179.225.244';
var _port='3000';

function getToday(){
    var today = new Date();
    var tday = new Date(today.getFullYear(), (today.getMonth()+1), today.getDate()).getTime();
    return tday ;
}
function getLastWeek(){
    var today = new Date();
    var lastWeek = new Date(today.getFullYear(), (today.getMonth()+1), today.getDate() - 7).getTime();
    return lastWeek ;
}
function getLastMonth(){
    var today = new Date();
    var lastMonth = new Date(today.getFullYear(), (today.getMonth()+1), today.getDate() - 30).getTime();
    return lastMonth ;
}
function getLastYear(){
    var today = new Date();
    var lastYear = new Date(today.getFullYear(), (today.getMonth()+1), today.getDate() - 365).getTime();
    return lastYear ;
}


router.get('/myyabs', function(req, res) {
  if(req.session.user==null || req.session.user=='')
  {
     res.redirect("/");
  }
  else
  {
    var username=req.session.user.name;
    var is_business_admin=req.session.user.is_business_admin;
    var id=req.session.user._id;
    var businessid=req.session.user.business_id;
    var options = {host:_host,port:_port,path:'/api/yab/mywebyabs/'+id+'/'+businessid};
      http.get(options, function (http_res) {
             var data = "";
             http_res.on("data", function (chunk) {
                 data += chunk;
             }).on("end", function () {
                 if(data)
                 {
                   yabdata = JSON.parse(data);
                   res.render('my-yabs',{ 'uname': username,'is_business_admin':is_business_admin,'yab_exist':yabdata[0],'all_yabs':yabdata[1],'all_yabs_details':yabdata[2],'business_details':yabdata[3]});
                 }
             }).on('error', function(e){
             console.log(e);
             res.redirect("/post");
            });
       }).on('error', function(e){
             console.log(e);
             res.redirect("/post");
      });
  }
});

router.get('/post', function(req, res) {
  if(req.session.user==null || req.session.user=='')
  {
     res.redirect("/");
  }
  else
  {
       var username=req.session.user.name;
       var userid=req.session.user._id;
       var is_business_admin=req.session.user.is_business_admin;
       var businessid=req.session.user.business_id;
       
       var today = getToday();
       var lastWeek = getLastWeek();
       var lastMonth = getLastMonth();
       var lastYear = getLastYear();
       
       Business.findOne({'_id':businessid},function(err,businesses){
          var is_push=businesses.is_push;
          var is_send_all=businesses.is_send_all;
          var yabperweek=businesses.yabperweek;
          var yabpermonth=businesses.yabpermonth;
          var yabperyear=businesses.yabperyear;
          var yabperweekleft,yabpermonthleft,yabperyearleft;
          var weekcount=0,monthcount=0,yearcount=0;
          
          Yab.find({'business_id':businessid},function(err,yabs){
            if(yabs)
            {
              for(var y in yabs)
              {
                var post_date=yabs[y].post_date;
                var td = new Date(post_date);
                var post_time=new Date(td.getFullYear(), (td.getMonth()+1), td.getDate()).getTime();
                if(post_time > lastWeek)
                {
                  weekcount+=1;
                }
                if(post_time > lastMonth)
                {
                  monthcount+=1;
                }
                if(post_time > lastYear)
                {
                  yearcount+=1;
                }
              }
              yabperweekleft=yabperweek-weekcount;
              yabpermonthleft=yabpermonth-monthcount;
              yabperyearleft=yabperyear-yearcount;
            }
            else
            {
               yabperweekleft=yabperweek;
               yabpermonthleft=yabpermonth;
               yabperyearleft=yabperyear;
            }
            res.render('yab-post', { 'uname': username,'userid':userid,'is_business_admin':is_business_admin,'is_push':is_push,'is_send_all':is_send_all,'yabperweekleft':yabperweekleft,'yabpermonthleft':yabpermonthleft,'yabperyearleft':yabperyearleft});
          });
     });
  }
});

module.exports = router;

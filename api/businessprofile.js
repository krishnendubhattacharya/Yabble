var express = require('express');
var mongoose = require('mongoose');
var Business = require('../models/businessmodel');
var Member = require('../models/membermodel');
var router = express.Router();
var session = require('express-session');
var md5 = require('MD5');
var moment = require('moment');


router.get('/', function(req, res, next) {
    var all_businesses=[];
    var data=[];
    var business_exist=0;
    Business.find({},function(err,businesses){
      if(businesses)
      {
        business_exist=1;
        for(var m in businesses)
        {
            var businessdetail;
            businessdetail = ({ "id": businesses[m]._id,'name': businesses[m].name,"username": businesses[m].username,"is_active": businesses[m].is_active,"registration_date": businesses[m].registration_date,"total_member": businesses[m].total_member});
            all_businesses.push(businessdetail);
        }
      }
      else
      {
       business_exist=0;
      }
       data[0]=business_exist;
       data[1]=all_businesses;
       res.send(data);
    });
});

router.post('/add', function(req, res, next) {
    var name = req.body.name;
    var username = req.body.username; 
    var bio = req.body.bio;
    var facebook = req.body.facebook;
    var twitter = req.body.twitter;
    var instagram = req.body.instagram;
    var _yabperweek = req.body.yabperweek;
    var _yabpermonth = req.body.yabpermonth;
    var _yabperyear = req.body.yabperyear;
    var _userperaccount = req.body.userperaccount;
    var ispush = req.body.is_push;
    var issendall = req.body.is_send_all;
    var issearchzip = req.body.is_search_zip;
    var isactive = req.body.is_active;
    var is_active,is_search_zip,is_send_all,is_push,yabperweek,yabpermonth,yabperyear,image,userperaccount;
    if(isactive==1)
    {
      is_active=1;
    }
    else
    {
      is_active=0;
    }
    if(ispush==1)
    {
      is_push=1;
    }
    else
    {
      is_push=0;
    }
    if(issendall==1)
    {
      is_send_all=1;
    }
    else
    {
      is_send_all=0;
    }
    if(issearchzip==1)
    {
      is_search_zip=1;
    }
    else
    {
      is_search_zip=0;
    }
    if(_yabperweek===undefined)
     {
       yabperweek=0;
     }
     else
     {
       yabperweek=_yabperweek;
     }
     if(_yabpermonth===undefined)
     {
       yabpermonth=0;
     }
     else
     {
       yabpermonth=_yabpermonth;
     }
     if(_yabperyear===undefined)
     {
       yabperyear=0;
     }
     else
     {
       yabperyear=_yabperyear;
     }
     if(_userperaccount===undefined)
     {
       userperaccount=0;
     }
     else
     {
       userperaccount=_userperaccount;
     }
     if(facebook===undefined)
     {
       facebook='';
     }
     else
     {
       facebook=facebook;
     }
     if(twitter===undefined)
     {
       twitter='';
     }
     else
     {
       twitter=twitter;
     }
     if(instagram===undefined)
     {
       instagram='';
     }
     else
     {
       instagram=instagram;
     }
     if(req.files.profile_picture===undefined)
     {
       image='';
     }
     else
     {
       image=req.files.profile_picture.name;
     }
     Business.findOne({"username":username},function(err,businessfind){
      if(businessfind=='' || businessfind==null)
      {
            var date = new Date();
            var registration_date = moment(date).format('YYYY-MM-DD');
            
            var _business=new Business({'name':name,'username':username,'bio':bio,'image':image,'facebook':facebook,'twitter':twitter,'instagram':instagram,'registration_date':registration_date,'is_active':is_active,'yabperweek':yabperweek,'yabpermonth':yabpermonth,'yabperyear':yabperyear,'userperaccount':userperaccount,'is_push':is_push,'is_send_all':is_send_all,'is_search_zip':is_search_zip,'total_member':0});
            _business.save(function(err) {
                  if (err) res.redirect("/admin/business/add");
            });
            res.redirect("/admin/business");
      }
     else
      {
         res.redirect("/admin/business/add");
      }
    });
});

router.get('/view/:id', function(req, res, next) {
   var id = req.params.id;
    Business.findOne({"_id":id},function(err,businessview){
        if (err) {
           res.send('error');
        }
        else if(businessview=='' || businessview==null)
        {
           res.send('error');
        }
        else 
        {
          res.send(businessview);
        }
    });
});

router.get('/delete/:id', function(req, res, next) {
  var id = req.params.id;
  Business.findOne({"_id":id},function(err,businessfind){
        if (err) {
           res.send('error');
        }
        else if(businessfind=='' || businessfind==null)
        {
           res.send('error');
        }
        else 
        {
          Business.remove({ '_id': id },function(err,businessremove){
            res.send('success');
          });
        }
   });
});

router.get('/active/:id', function(req, res, next) {
  var id = req.params.id;
  Business.findOne({"_id":id},function(err,businessfind){
        if (err) {
           res.send('error');
        }
        else if(businessfind=='' || businessfind==null)
        {
           res.send('error');
        }
        else 
        {
          Business.update({ '_id': id }, { $set: {'is_active': 1}}, function (err, businessactive) {
            res.send('success');
          });
        }
     });
});

router.get('/deactive/:id', function(req, res, next) {
  var id = req.params.id;
  Business.findOne({"_id":id},function(err,businessfind){
        if (err) {
           res.send('error');
        }
        else if(businessfind=='' || businessfind==null)
        {
           res.send('error');
        }
        else 
        {
          Business.update({ '_id': id }, { $set: {'is_active': 0}}, function (err, businessactive) {
            res.send('success');
          });
        }
     });
});


router.get('/edit/:id', function(req, res, next) {
  var id = req.params.id;
  Business.findOne({"_id":id},function(err,businessfind){
        if (err) {
           res.send('error');
        }
        else if(businessfind=='' || businessfind==null)
        {
           res.send('error');
        }
        else 
        {
           res.send(businessfind);
        }
   });
});  

router.post('/postedit', function(req, res) {
    var name = req.body.name;
    var username = req.body.username; 
    var bio = req.body.bio;
    var facebook = req.body.facebook;
    var twitter = req.body.twitter;
    var instagram = req.body.instagram;
    var _yabperweek = req.body.yabperweek;
    var _yabpermonth = req.body.yabpermonth;
    var _yabperyear = req.body.yabperyear;
    var _userperaccount = req.body.userperaccount;
    var ispush = req.body.is_push;
    var issendall = req.body.is_send_all;
    var issearchzip = req.body.is_search_zip;
    var isactive = req.body.is_active;
    var businessid = req.body.userid; 
    var is_active,is_search_zip,is_send_all,is_push,yabperweek,yabpermonth,yabperyear,image,userperaccount;
    
    if(isactive==1)
    {
      is_active=1;
    }
    else
    {
      is_active=0;
    }
    if(ispush==1)
    {
      is_push=1;
    }
    else
    {
      is_push=0;
    }
    if(issendall==1)
    {
      is_send_all=1;
    }
    else
    {
      is_send_all=0;
    }
    if(issearchzip==1)
    {
      is_search_zip=1;
    }
    else
    {
      is_search_zip=0;
    }
    if(_yabperweek===undefined)
     {
       yabperweek=0;
     }
     else
     {
       yabperweek=_yabperweek;
     }
     if(_yabpermonth===undefined)
     {
       yabpermonth=0;
     }
     else
     {
       yabpermonth=_yabpermonth;
     }
     if(_yabperyear===undefined)
     {
       yabperyear=0;
     }
     else
     {
       yabperyear=_yabperyear;
     }
     if(_userperaccount===undefined)
     {
       userperaccount=0;
     }
     else
     {
       userperaccount=_userperaccount;
     }
     if(facebook===undefined)
     {
       facebook='';
     }
     else
     {
       facebook=facebook;
     }
     if(twitter===undefined)
     {
       twitter='';
     }
     else
     {
       twitter=twitter;
     }
     if(instagram===undefined)
     {
       instagram='';
     }
     else
     {
       instagram=instagram;
     }
     if(req.files.profile_picture===undefined)
     {
       image='';
     }
     else
     {
       image=req.files.profile_picture.name;
     }
     
        Business.findOne({"_id":businessid},function(err,businessfind){
        if (err) {
           res.redirect("/admin/business/edit/"+businessid);
        }
        else if(businessfind=='' || businessfind==null)
        {
           res.redirect("/admin/business/edit/"+businessid);
        }
        else 
        {     
            if(image=='')
            {
              image=businessfind.image;
            }
            else
            {
              image=image;
            }
            Business.findOne({'_id':{$ne:businessid},"username":username},function(err,businss){
              if(businss=='' || businss==null)
              {
                  Business.update({ '_id': businessid }, { $set: {'name':name,'username':username,'bio':bio,'image':image,'facebook':facebook,'twitter':twitter,'instagram':instagram,'is_active':is_active,'yabperweek':yabperweek,'yabpermonth':yabpermonth,'yabperyear':yabperyear,'userperaccount':userperaccount,'is_push':is_push,'is_send_all':is_send_all,'is_search_zip':is_search_zip}}, function (err, doc) {
                   if (err) {
                     res.redirect("/admin/business/edit/"+businessid);
                    }                 
                  });
                  res.redirect("/admin/business");
              }
             else
              {
                 res.redirect("/admin/business/edit/"+businessid);
              }
          });
        }
     });      
});

router.post('/memberedit', function(req, res) {
    var name = req.body.name;
    var bio = req.body.bio;
    var facebook = req.body.facebook;
    var twitter = req.body.twitter;
    var instagram = req.body.instagram;
    var businessid = req.body.userid; 
    
     if(facebook===undefined)
     {
       facebook='';
     }
     else
     {
       facebook=facebook;
     }
     if(twitter===undefined)
     {
       twitter='';
     }
     else
     {
       twitter=twitter;
     }
     if(instagram===undefined)
     {
       instagram='';
     }
     else
     {
       instagram=instagram;
     }
     if(req.files.profile_picture===undefined)
     {
       image='';
     }
     else
     {
       image=req.files.profile_picture.name;
     }
     
        Business.findOne({"_id":businessid},function(err,businessfind){
        if (err) {
           res.redirect("/business/edit");
        }
        else if(businessfind=='' || businessfind==null)
        {
           res.redirect("/business/edit");
        }
        else 
        {     
            if(image=='')
            {
              image=businessfind.image;
            }
            else
            {
              image=image;
            }
            
           Business.update({ '_id': businessid }, { $set: {'name':name,'bio':bio,'image':image,'facebook':facebook,'twitter':twitter,'instagram':instagram}}, function (err, doc) {
                   if (err) {
                     res.redirect("/business/edit");
                    }                 
            });
            res.redirect("/business/edit");
        }
     });      
});


module.exports = router;

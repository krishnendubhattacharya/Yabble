var express = require('express');
var mongoose = require('mongoose');
var AppMember = require('../models/appmembermodel');
/*******************APP**************************/
var User = require('../models/appmembermodel');
var UserSetting=require('../models/appusersettingmodel');
var appUser=require('../models/appusers');
var yabapps=require('../models/yabappmodel')
var UsrSettings=require('../models/usersettings');
var appyab=require('../models/appyabcommentmodel');
var UserProfile=require('../models/userprofile');
var member=require('../models/membermodel');
var business=require('../models/businessmodel');
var AUTH_KEY = 'acea920f7412b7Ya7be0cfl2b8c937Bc9';
var nodemailer=require("nodemailer");
var transporter = nodemailer.createTransport();
/*******************App*************************/
var router = express.Router();
var session = require('express-session');
var md5 = require('MD5');
var html = require('html');
var moment = require('moment');

/* Member List Page */
router.get('/', function(req, res) {
    var member_exist=0;
    var all_members=[];
    var data=[];
     AppMember.find({},function(err,members){
      if(members)
      {
        member_exist=1;
        for(var m in members)
        {
            var userdetail;
            userdetail = ({ "id": members[m]._id,"username": members[m].username,"email": members[m].email,"is_active": members[m].is_active,"registration_date": members[m].registration_date});
            all_members.push(userdetail);
        }
      }
      else
      {
       member_exist=0;
      }
        data[0]=member_exist;
        data[1]=all_members;
        res.send(data);
   });
});

router.get('/delete/:id', function(req, res) {
    var id = req.params.id;
     AppMember.findOne({"_id":id},function(err,memberfind){
        if (err) {
           res.send('error');
        }
        else if(memberfind=='' || memberfind==null)
        {
           res.send('error');
        }
        else 
        {
          AppMember.remove({ '_id': id },function(err,memberremove){
            res.send('success');
          });
        }
     });
});

router.get('/active/:id', function(req, res) {
    var id = req.params.id;
     AppMember.findOne({"_id":id},function(err,memberfind){
        if (err) {
           res.send('error');
        }
        else if(memberfind=='' || memberfind==null)
        {
           res.send('error');
        }
        else 
        {
          AppMember.update({ '_id': id }, { $set: {'is_active': 1}}, function (err, memberactive) {
            res.send('success');
          });
        }
     });
});

router.get('/deactive/:id', function(req, res) {
    var id = req.params.id;
     AppMember.findOne({"_id":id},function(err,memberfind){
        if (err) {
           res.send('error');
        }
        else if(memberfind=='' || memberfind==null)
        {
           res.send('error');
        }
        else 
        {
          AppMember.update({ '_id': id }, { $set: {'is_active': 0}}, function (err, memberdeactive) {
            res.send('success');
          });
        }
     });
});

router.get('/view/:id', function(req, res) {
    var id = req.params.id;
    var data=[];
       AppMember.findOne({"_id":id},function(err,memberview){
        if (err) {
           res.send('error');
        }
        else if(memberview=='' || memberview==null)
        {
           res.send('error');
        }
        else 
        {
             data[0]=memberview;
             res.send(data);
        }
     });
});

router.get('/edit/:id', function(req, res) {
    var id = req.params.id;
    var data=[];
    AppMember.findOne({"_id":id},function(err,memberfind){
        if (err) {
           res.send('error');
        }
        else if(memberfind=='' || memberfind==null)
        {
           res.send('error');
        }
        else 
        {
           data[0]=memberfind;
           res.send(data);
        }
     });
});

router.post('/postedit', function(req, res) {
  var name = req.body.uname;
  var username = req.body.username;
  var email = req.body.email;
  var isactive = req.body.is_active;
  var memberid = req.body.userid; 
  var bio = req.body.bio;
  var dob = req.body.dob;
  var gender = req.body.optionsRadios;
  var facebook = req.body.facebook;
  var twitter = req.body.twitter;
  var instagram = req.body.instagram;
  
  var is_active;

  if(isactive==1)
  {
    is_active=1;
  }
  else
  {
    is_active=0;
  }

    AppMember.findOne({"_id":memberid},function(err,memberfind){
        if (err) {
           res.send('error');
        }
        else if(memberfind=='' || memberfind==null)
        {
           res.send('error');
        }
        else 
        {
          AppMember.findOne( {'_id':{$ne:memberid},"email": email},function(err,membr){
             if(membr=='' || membr==null)
             {
                  AppMember.update({ '_id': memberid }, { $set: {'name':name,'email':email,'username':username,'bio':bio,'gender':gender,'facebook':facebook,'twitter':twitter,'instagram':instagram,'is_active':is_active}}, function (err, doc) {
                   if (err) {
                     res.send('error');
                    }                 
                  });
                  res.send('success');
             }
             else
             {
                res.send('memberexist');
             }
          });
        }
     });
});

/*************************************App************************************/


router.post('/login', function(req, res, next) {
    var _authkey = req.body.authkey;
    var _username=req.body.user;
    var _device_token_id = req.body.device_token_id;
    var _lat = req.body.lat;
    var _long = req.body.longi; 
    var _password= md5(req.body.password);
    var date = new Date();
    var now_utc = moment(date).format('YYYY-MM-DD H:mm:ss')
    
if (_authkey != '') {
        if (_authkey == AUTH_KEY) {
            
            if (_device_token_id != '') {

                if (_username != '' && _password != '') {
  
                User.findOne({ 'username': _username, 'password': _password }, function (err, item) {
                    console.log(item);
                        if (item) {

                            User.update({ '_id': item._id }, { $set: { 'is_logged_in': 1, 'device_token': _device_token_id, 'last_logged_in': now_utc, 'latitude': _lat, 'longitude': _long }}, function (err, doc) {
                                    
                            });
                            UserSetting.findOne({ 'user_id': item._id }, function (err, UserSett) {
                                console.log(UserSett);
                                if (UserSett) {
                                    appUser.LastID=({ "id": item._id });
                                    appUser.ack="1";
                                    appUser.userdetail=({ id:{"$id":item._id}, "username": item.username, "name": item.name , "img": item.image, "device_token_id": item.device_token,"yabreach":UserSett.yabreach,"showaddress":UserSett.showaddress, "email": item.email });
                                    appUser.msg = "Success";
                                    console.log(appUser);
                                    res.send(appUser);
                                }
                                else
                                {
                                  appUser.LastID=({ "id": item._id });
                                  appUser.Ack="1";
                                  appUser.userdetail=({ id:{"$id":item._id}, "username": item.username, "name": item.name , "img": item.image, "device_token_id": item.device_token,"yabreach":"","showaddress":"", "email": item.email });
                                  appUser.msg = "Success";
                                  console.log(appUser);
                                  res.send(appUser);
                                }
                            });
                        }
                        else
                        {
                            
                            appUser.LastID = "1";
                            appUser.Ack = "0";
                            appUser.userdetail="";
                            appUser.msg = "Login error. Invalid username/password or account not active";
                            res.send(appUser);
                        }
                    });

                }
                else
                {
                    appUser.LastID = "1";
                    appUser.Ack = "0";
                    appUser.userdetail="";
                    appUser.msg = "Please provide username and password";
                    res.send(appUser);
                }
            }
            else
            {
                appUser.LastID = "1";
                appUser.Ack = "0";
                appUser.userdetail="";
                appUser.msg = "Please provide device token";
                res.send(appUser);
            }
        }
        else
        {
            appUser.LastID = "1";
            appUser.Ack = "0";
            appUser.userdetail="";
            appUser.msg = "Invalid auth key";
            res.send(appUser);
        }
    }
    else
    {
        appUser.LastID = "1";
        appUser.Ack = "0";
        appUser.userdetail="";
        appUser.msg = "Please provide auth key";
        res.send(appUser);
    }
 
});



router.get('/logout',function(req,res,next){
    var _authkey = req.body.authkey;
    var _userID = req.body.userID;
    var _device_token_id = req.body.device_token_id;

     if (_authkey != '') {
      console.log(_authkey);
        if (_authkey == AUTH_KEY) {
            if (_device_token_id != '') {
                if (_userID != '') {
                    User.findOne({'_id':_userID},function(err,item){
                        if (item) {
                            console.log(item);
                            User.update({'_id':item._id},{$set:{'is_logged_in': 0}},function(err,doc){
                                
                            });

                                appUser.LastID=({ "id": item._id });
                                appUser.ack="1";
                                appUser.userdetail=({ "id": item._id, "username": item.username, "device_token_id": item.device_token, "email": item.email });
                                appUser.msg = "You have successfully logged out";
                                res.send(appUser);
                        }
                        else
                        {
                            appUser.LastID = '';
                            appUser.Ack = 0;
                            appUser.userdetail="";
                            appUser.msg = 'Invalid user';
                            res.send(appUser);
                        }
                    });
                }
                else
                {
                    appUser.LastID = '';
                    appUser.Ack = 0;
                    appUser.userdetail="";
                    appUser.msg = 'Invalid user';
                    res.send(appUser);
                }
            }
            else
            {
                appUser.LastID = '';
                appUser.Ack = 0;
                appUser.userdetail="";
                appUser.msg = 'Please provide device token';
                res.send(appUser);
            }
        }
        else
        {
            appUser.LastID = '';
            appUser.Ack = 0;
            appUser.userdetail="";
            appUser.msg = 'Invalid auth key';
            res.send(appUser);
        }
    }
    else
    {
        appUser.LastID = '';
        appUser.Ack = 0;
        appUser.userdetail="";
        appUser.msg = 'Please provide auth key';
        res.send(appUser);
    }
   
});



router.post('/forgotPassword',function(req,res,next){
    var _authkey = req.body.authkey;
    var _email = req.body.email;
    var _device_token_id = req.body.device_token_id;
    if (_authkey != '') {
        if (_authkey == AUTH_KEY) {
            if (_device_token_id != '') {
                if (_email != '') {
                    User.findOne({'email': _email},function(err,item){
                        if (item) {
                            var alphabet = "abcdefghijklmnopqrstuwxyzABCDEFGHIJKLMNOPQRSTUWXYZ0123456789";
                            var pass = [];
                            var result='';
                            for (var i = 0; i < 8; i++) {
                                var rnum = Math.floor(Math.random() * alphabet.length);
                                result += alphabet.substring(rnum,rnum+1);
                            }
                                var newPass = result;
                                User.update({ '_id': item._id }, { $set: { 'password': md5(newPass) } }, function (err, doc) {
                                });
                                var to = item.email;
                                var subject = "Yabble forgot password";
                                var message = "Hi User,<br/><br/>Your password has been changed on Yabble.<br/>Your new login details:<br/>Email: " + item.email + "<br/>Password: " + newPass + "<br/><br/>You can also change you password by logging into your account.<br/><br/><br/>Thanks,<br/>Yabble";
                                var headers = "MIME-Version: 1.0" + "\r\n";
                                headers += "Content-type:text/html;charset=UTF-8" + "\r\n";
                                headers += 'From: <noreply@yabble.com>' + "\r\n";

                                


                                appUser.LastID = item._id;
                                appUser.Ack = 1;
                                appUser.UserDetails = ({ "id": item._id, "username": item.username, "device_token_id": item.device_token, "email": item.email });
                                appUser.Msg = 'Your new password has been sent to your mail';
                                res.send(appUser);
                        }
                        else
                        {
                            appUser.LastID = '';
                            appUser.Ack = 0;
                            appUser.userdetail="";
                            appUser.msg = 'Invalid user';
                            res.send(appUser);
                        }
                    });
                }
                else
                {
                    appUser.LastID = '';
                    appUser.Ack = 0;
                    appUser.userdetail="";
                    appUser.msg = 'Please provide email address';
                    res.send(appUser);
                }
            }
            else
            {
                appUser.LastID = '';
                appUser.Ack = 0;
                appUser.userdetail="";
                appUser.msg = 'Please provide device token';
                res.send(appUser);
            }
        }
        else
        {
            appUser.LastID = '';
            appUser.Ack = 0;
            appUser.userdetail="";
            appUser.msg = 'Invalid auth key';
            res.send(appUser);
        }
    }
    else
    {
        appUser.LastID = '';
        appUser.Ack = 0;
        appUser.userdetail="";
        appUser.msg = 'Please provide auth key';
        res.send(appUser);
    }
});


router.post('/changePassword',function(req,res,next){
    var _authkey = req.body.authkey;
    var _userID = req.body.userID;
    var _current_password = req.body.current_password;
    var _new_password = req.body.new_password;
    var _device_token_id = req.body.device_token_id;
    if(_authkey != '') {
        if (_authkey == AUTH_KEY) {
            if (_device_token_id != '') {
                User.findOne({'_id':_userID},function(err,item){
                        if (item) {
                            console.log( md5(_current_password));
                            console.log(_userID);
                            User.findOne({ '_id': _userID, 'password': md5(_current_password) }, function (err, user) {
                                if (user) {

                                    User.update({ '_id': _userID }, { $set: { 'password': md5(_new_password) } }, function (err, result) { 
                                        console.log(result);

                                        appUser.LastID = ({ "id": user._id });
                                        appUser.Ack = 1;
                                        appUser.userdetail = ({ id:{"$id":user._id}, "username": user.username, "device_token_id": user.device_token, "email": user.email });
                                        appUser.msg = 'Your password updated successfully';
                                        res.send(appUser);
                                    });
                                    console.log('if part');
                                }
                                else
                                {
                                    console.log('else part');
                                    appUser.LastID = '';
                                    appUser.Ack = 0;
                                    appUser.userdetail="";
                                    appUser.msg = 'Please enter correct current password';
                                    res.send(appUser);
                                }
                               
                            });
                        }
                        else
                        {
                            appUser.LastID = '';
                            appUser.Ack = 0;
                            appUser.userdetail="";
                            appUser.msg = 'Invalid user';
                            res.send(appUser);
                        }
               }); 
                
            }
            else
            {
                appUser.LastID = '';
                appUser.Ack = 0;
                appUser.userdetail="";
                appUser.msg = 'Please provide device token';
                res.send(appUser);
            }
        }
        else
        {
            appUser.LastID = '';
            appUser.Ack = 0;
            appUser.userdetail="";
            appUser.msg = 'Invalid auth key';
            res.send(appUser);
        }
    }
    else
    {
        appUser.LastID = '';
        appUser.Ack = 0;
        appUser.userdetail="";
        appUser.msg = 'Please provide auth key';
        res.send(appUser);
    }
});

router.post('/userSetting',function(req,res,next){
    var _authkey = req.body.authkey;
    var _userID = req.body.userID;
    var _device_token_id = req.body.device_token_id;
    var _yabreach=req.body.yabreach;
    var _show_address=req.body.show_address;
    if(_authkey != '') {
        if (_authkey == AUTH_KEY) {
            if (_device_token_id != '') {

                User.findOne({'_id':_userID},function(err,item){
                  console.log(item);
                        if (item) {

                           
                            UserSetting.findOne({'user_id':item._id },function(err,user){
                              console.log("user");
                                console.log(user);
                            if (user) {
                                
                                UserSetting.update({ 'user_id': _userID }, { $set: { 'yabreach': _yabreach,'is_show_address': _show_address}}, function (err, result) {
                                    console.log(result);
                                 });
                            }
                            else
                            {
                              console.log("else part");
                                var _cms=new UserSetting({'user_id':_userID,'yabreach': _yabreach,'is_show_address' : _show_address});
                                  _cms.save(function(err,data) {
                                   console.log(data);

                                   UserSetting.findOne({'user_id':data.user_id},function(err,settings){
                                
                                        if (settings) {

                                            UsrSettings.LastID = ({ "id": settings._id });
                                            UsrSettings.Ack = 1;
                                            UsrSettings.SettingDetails = ({id : { "id": settings._id}, "user_id": settings.user_id, "yabreach": settings.yabreach, "is_show_address": settings.is_show_address });
                                            UsrSettings.msg = 'Your setting has been updated successfully';
                                             console.log(settings);
                                            res.send(UsrSettings);
                                        }

                                    });
                                     
                                  });
                            }
                        });
                            console.log(_userID);
                            UserSetting.findOne({'user_id':_userID},function(err,settings){
                                
                            if (settings) {

                                UsrSettings.LastID = ({ "id": settings._id });
                                UsrSettings.Ack = 1;
                                UsrSettings.SettingDetails = ({id : { "id": settings._id}, "user_id": settings.user_id, "yabreach": settings.yabreach, "is_show_address": settings.is_show_address });
                                UsrSettings.msg = 'Your setting has been updated successfully';
                                 console.log(settings);
                                res.send(UsrSettings);
                            }

                        });
                    }
                    else
                    {
                        UsrSettings.LastID = '';
                        UsrSettings.Ack = 0;
                        UsrSettings.msg = 'Invalid user';
                    }
                    });
            }
            else
            {
                UsrSettings.LastID = '';
                UsrSettings.Ack = 0;
                UsrSettings.msg = 'Please provide device token';
            }

        }
        else
        {
            UsrSettings.LastID = '';
            UsrSettings.Ack = 0;
            UsrSettings.msg = 'Invalid auth key';
        }
    }
    else
    {
        UsrSettings.LastID = '';
        UsrSettings.Ack = 0;
        UsrSettings.msg = 'Please provide auth key';
    }
});


router.get('/userInfo/:authkey/:userID/:device_token_id/',function(req,res,next){
    var _authkey = req.params.authkey;
    var _userID = req.params.userID;
    var _device_token_id = req.params.device_token_id;
    if(_authkey != '') {
        if (_authkey == AUTH_KEY) {
            if (_device_token_id != '') {
                User.findOne({'_id':_userID},function(err,item){
                    console.log(item);
                        if (item) {
                            appUser.LastID = ({"$id":item._id});
                            appUser.Ack = 1;
                            appUser.userdetails = ({ id:{"$id":item._id}, "name": item.name, "username": item.username, "bio": item.bio ,"gender": item.gender, "dob": item.dob, "facebook": item.facebook, "instagram": item.instagram ,"twitter": item.twitter, "is_social_show": item.is_social_show, "img": item.image, "latitude": item.latitude ,"longitude": item.longitude, "last_logged_in": item.last_logged_in, "device_token_id": item.device_token_id, "email": item.email });
                            appUser.Msg = 'Success';
                            res.send(appUser);
                        }
                        else
                        {
                            appUser.LastID = '';
                            appUser.Ack = 0;
                            appUser.userdetails ="";
                            appUser.msg = 'Invalid user';
                            res.send(appUser);
                        }
                    });
            }
            else
            {
                appUser.LastID = '';
                appUser.Ack = 0;
                appUser.userdetails ="";
                appUser.msg = 'Please provide device token';
                res.send(appUser);
            }
        }
        else
        {
            appUser.LastID = '';
            appUser.Ack = 0;
            appUser.userdetails ="";
            appUser.msg = 'Invalid auth key';
            res.send(appUser);
        }
    }
    else
    {
        appUser.LastID = '';
        appUser.Ack = 0;
        appUser.userdetails ="";
        appUser.msg = 'Please provide auth key';
        res.send(appUser);
    }
});

router.get('/userProfile/:authkey/:userID/:device_token_id/',function(req,res,next){
    var _authkey = req.params.authkey;
    var _userID = req.params.userID;
    var _device_token_id = req.params.device_token_id;
    if(_authkey != '') {
        if (_authkey == AUTH_KEY) {
            if (_device_token_id != '') {
                User.findOne({'_id':_userID},function(err,item){
                    if(item){
                        yabapps.findOne({'user_id':_userID},function(err,yab){
                            console.log(yab);
                            UserProfile.UserID=_userID;
                            UserProfile.Ack=1;
                            if (yab) {
                              UserProfile.totalyabs=yab.length;
                            }
                            else
                            {
                              UserProfile.totalyabs=0;
                            }
                            
                            UserProfile.name=item.name;
                            UserProfile.bio=item.bio;
                            UserProfile.username=item.username;
                            UserProfile.img=item.image;
                            res.send(UserProfile);
                        });

                    }
                    else
                    {
                        member.findOne({'_id':_userID},function(err,resultweb){
                            if(resultweb)
                            {
                                business.findOne({'_id':resultweb.business_id},function(err,result){
                                    yabapps.findOne({'user_id':_userID},function(err,app){
                                        UserProfile.UserID=_userID;
                                        UserProfile.Ack=1;
                                        UserProfile.totalyabs=app.length;
                                        UserProfile.name=result.name;
                                        UserProfile.bio=result.bio;
                                        UserProfile.username=result.username;
                                        UserProfile.img=result.image;
                                        res.send(UserProfile);
                                    });
                                });
                            }
                            else
                            {
                                UserProfile.LastID='';
                                UserProfile.Ack=0;
                                UserProfile.msg='Invalid user';
                                res.send(UserProfile);
                            }
                        });
                    }
                });
            }
            else
            {
                UserProfile.LastID='';
                UserProfile.Ack=0;
                UserProfile.msg='Please provide device token';
                res.send(UserProfile);
            }
        }
        else
        {
            UserProfile.LastID='';
            UserProfile.Ack=0;
            UserProfile.msg='Invalid auth key';
            res.send(UserProfile);
        }
    }
    else
    {
        UserProfile.LastID='';
        UserProfile.Ack=0;
        UserProfile.msg='Please provide auth key';
        res.send(UserProfile);
    }
});

router.post('/postComment',function(req,res,next){
    var _authkey = req.body.authkey;
    var _yabid=req.body.yabid;
    var _userID = req.body.userid;
    var _comment=req.body.comment;
    var date = new Date();
    var _device_token_id = req.body.device_token_id;
     if(_authkey != '') {
        if (_authkey == AUTH_KEY) {
            if (_device_token_id != '') {
                yabapps.findOne({'_id':_yabid},function(err,item){
                    
                    if(item){
                        User.findOne({'_id':_userID},function(err,result){
                            console.log(_userID);
                            if(result)
                            {
                                    var documents=new appyab({'user_id':_userID,'yab_id':_yabid,'comment':_comment,'post_date':moment(date).format('YYYY-MM-DD H:mm:ss')});
                                    documents.save(function(err,data) {
                                    appUser.LastID=data._id;
                                    appUser.Ack = 1;
                                    appUser.msg = 'Your comment has been posted';
                                    res.send(appUser);
                                 });
                                  
                            }
                            else
                               {
                                  appUser.LastID = '';
                                  appUser.Ack = 0;
                                  appUser.userdetail="";
                                  appUser.msg = 'Invalid user';
                                  res.send(appUser);
                               }
                        });
                    }
                    else
                       {
                          appUser.LastID = '';
                          appUser.Ack = 0;
                          appUser.userdetail="";
                          appUser.msg = 'Invalid yab';
                          res.send(appUser);
                       }
                });
            }
            else
            {
                  appUser.LastID = '';
                  appUser.Ack = 0;
                  appUser.userdetail="";
                  appUser.msg = 'Please provide device token';
                  res.send(appUser);
            }
        }
        else
        {
          appUser.LastID = '';
          appUser.Ack = 0;
          appUser.userdetail="";
          appUser.msg = 'Invalid auth key';  
          res.send(appUser); 
        }
    }
    else
    {
        appUser.LastID = '';
        appUser.Ack = 0;
        appUser.userdetail="";
        appUser.msg = 'Please provide auth key'; 
        res.send(appUser);
    }
});


router.post('/updateuserposition',function(req,res,next){
    var _authkey = req.body.authkey;
    var _userID = req.body.userID;
    var _device_token_id = req.body.device_token_id;
    //console.log("iugefs");
    var _lat = req.body.lat;
    var _long = req.body.longi; 
    
    if(_authkey != '') {
        if (_authkey == AUTH_KEY) {
            if (_device_token_id != '') {
                if(_userID!=''){
                    User.findOne({'_id':_userID},function(err,result){
                    if(result)
                    {
                        User.update({ '_id': _userID },{ $set: { 'latitude': _lat,'longitude': _long}}, function(err,usr){
                            appUser.LastID=({"$id":result._id});
                            appUser.Ack=1;
                            appUser.UserDetails=({ id:{"$id":result._id}, "username": result.username, "device_token_id": result.device_token, "email": result.email });
                            appUser.msg='Your position updated successfully';
                            res.send(appUser);
                        });
                    }
                    else
                    {
                        appUser.LastID='';
                        appUser.Ack=0;
                        appUser.userdetail="";
                        appUser.msg='Invalid user';
                        res.send(appUser);
                    }
                });
            }
            else
            {
                appUser.LastID='';
                appUser.Ack=0;
                appUser.userdetail="";
                appUser.msg='Invalid user';
                res.send(appUser);
            }
        }
        else
        {
            appUser.LastID='';
            appUser.Ack=0;
            appUser.userdetail="";
            appUser.msg='Please provide device token';
            res.send(appUser);
        }
    }
    else
    {
        appUser.LastID='';
        appUser.Ack=0;
        appUser.userdetail="";
        appUser.msg='Invalid auth key';
        res.send(appUser);
    }
}
else
{
    appUser.LastID='';
    appUser.Ack=0;
    appUser.userdetail="";
    appUser.msg='Please provide auth key';
    res.send(appUser);
}
});

router.post('/signup',function(req,res,next){
    var _authkey = req.body.authkey;
    var _device_token_id = req.body.device_token_id;
    var _email = req.body.email;
    var _password = req.body.password;
    var _uname = req.body.uname;
    var date = new Date();
    var registration_date = moment(date).format('YYYY-MM-DD')
    if(_authkey != '') {
        if (_authkey == AUTH_KEY) {
            if (_device_token_id != '') {
                if(_email!='' && _uname!=''){
                    User.findOne({'email':_email},function(err,result){
                        
                        if(result)
                        {

                            appUser.LastID='';
                            appUser.Ack=0;
                            appUser.msg='Email already exist. Please use different email';
                            res.send(appUser);
                        }
                        else
                        {
                            User.findOne({'username':_uname},function(err,usr){
                                if (usr) {
                                  
                                    appUser.LastID='';
                                    appUser.Ack=0;
                                    appUser.msg='Username already exist. Please use different username';
                                    res.send(appUser);
                                }
                                else
                                {
                                    var documents=new User({'username':_uname,'email':_email,'password':md5(_password),'latitude':'0','longitude':'0','registration_date':registration_date,'device_token':_device_token_id,'is_logged_in':'0','last_logged_in':'0','is_active':'1'});
                                    documents.save(function(err,data) {
                                        var to = data.email;
                                    var subject = "Yabble registration";
                                    var message = "Hi "+data.username+"<br/><br/>You have successfully registered on Yabble.<br/>Your login details:<br/>Email: "+data.email+"<br/>Password: "+data.password+"<br/><br/><br/>Thanks,<br/>Yabble";
                                    var headers = "MIME-Version: 1.0" + "\r\n";
                                    headers += "Content-type:text/html;charset=UTF-8" + "\r\n";
                                    headers += 'From: <noreply@yabble.com>' + "\r\n";
                                    
                                    appUser.LastID=({"$id":data._id});
                                    appUser.Ack=1;
                                    appUser.userdetail=({ id:{"$id":data._id}, "username": data.username, "device_token_id": data.device_token, "email": data.email });
                                    appUser.msg='Registration Successful';
                                    res.send(appUser);
                                    });
                                }
                            });
                        }
                    });
              }
              else
              {
                appUser.LastID = '';
                appUser.Ack = 0;
                appUser.userdetail="";
                appUser.msg = 'Please provide email address and username';
                res.send(appUser);
              }
            }
            else
              {
                appUser.LastID = '';
                appUser.Ack = 0;
                appUser.userdetail="";
                appUser.msg = 'Please provide device token';
                res.send(appUser);
              }
        }
        else
          {
            appUser.LastID = '';
            appUser.Ack = 0;
            appUser.userdetail="";
            appUser.msg = 'Invalid auth key';
            res.send(appUser);
          }
    }
    else
      {
        appUser.LastID = '';
        appUser.Ack = 0;
        appUser.userdetail="";
        appUser.msg = 'Please provide auth key';
        res.send(appUser);
      }
});



/*router.post('/editprofile',function(req,res,next){
    var _authkey = req.body.authkey;
    var _userid=req.body.userid;
    var _uname=req.body.uname;
    var _device_token_id = req.body.device_token_id;
    var _email = req.body.email;
    var _name = req.body.name;
    var _bio = req.body.bio;
    var _dob = req.body.dob;
    var _gender = req.body.gender;
    var _facebook = req.body.facebook;
    var _twitter = req.body.twitter;
    var _instagram = req.body.instagram;
    var _show_social = req.body.show_social;
    var _imagewidth = req.body.imagewidth;
    var _imageheight=req.body.imageheight;
    var _img_name="";

    if(_authkey != '') {
        if (_authkey == AUTH_KEY) {
            if (_device_token_id != '') {
                if(_email!='' ){
                    User.findOne({'_id':_userid},function(err,reslt){
                        if (reslt) {
                            User.findOne({'_id':_userid ,'email':_email},function(err,result){
                                if(result){
                                    appUser.LastID='';
                                    appUser.Ack=0;
                                    appUser.msg='Email already exist. Please use different email';
                                    res.send(appUser);
                                }
                                else
                                {
                                    User.findOne({'_id':_userid ,'username':_uname},function(err,result){
                                        if(result){
                                            appUser.LastID='';
                                            appUser.Ack=0;
                                            appUser.msg='Username already exist. Please choose different';
                                            res.send(appUser);
                                        }
                                      });
                                        if(req.files.profile_picture===undefined)
                                         {
                                            _img_name='';
                                            
                                         }
                                         else
                                         {
                                            _img_name=req.files.profile_picture.name;
                                          
                                          }
                                            User.update({ '_id': _userid },{'username':_uname,'email':_email,'name':_name,'bio':_bio,'gender':_gender,'dob':_dob,'image':_img_name,'imagewidth':_imagewidth,'imageheight':_imageheight,'facebook':_facebook,'twitter':_twitter,'instagram':_instagram,'is_social_show':_show_social},function(err,data){
                                                User.findOne({'_id':_userid },function(err,usr){
                                                  console.log(_userid);
                                                  console.log(usr);
                                                    appUser.LastID=_userid;
                                                    appUser.Ack=1;
                                                    appUser.UserDetails=({ id:{"$id":_userid},"username":usr.username,"email":usr.email,"name":usr.name,"bio":usr.bio,"gender":usr.gender,"dob":usr.dob,"image":usr.image,"imagewidth":usr.imagewidth,"imageheight":usr.imageheight,"facebook":usr.facebook,"twitter":usr.twitter,"instagram":usr.instagram,"is_social_show":usr.is_social_show,"latitude":usr.latitude,"longitude":usr.longitude,"registration_date":usr.registration_date,"last_logged_in":usr.last_logged_in})
                                                    appUser.msg='Your profile has been edited successfully';
                                                    res.send(appUser);
                                                });
                                            });
                                      }
                                                           
                                    });
                                }    
                                else
                                {
                                    appUser.LastID='';
                                    appUser.Ack=0;
                                    appUser.userdetail="";
                                    appUser.msg='Invalid user';
                                    res.send(appUser); 
                                }
                   });
                   
                }
                else
                {
                    appUser.LastID='';
                    appUser.Ack=0;
                    appUser.userdetail="";
                    appUser.msg='Please provide email address';
                    res.send(appUser); 
                }
            }
            else
            {
                appUser.LastID='';
                appUser.Ack=0;
                appUser.userdetail="";
                appUser.msg='Please provide device token';
                res.send(appUser); 
            }
        }
        else
        {
            appUser.LastID='';
            appUser.Ack=0;
            appUser.userdetail="";
            appUser.msg='Invalid auth key';
            res.send(appUser); 
        }
    }
    else
    {
        appUser.LastID='';
        appUser.Ack=0;
        appUser.userdetail="";
        appUser.msg='Please provide auth key';
        res.send(appUser); 
    }
});
*/
router.get('/editprofile/:authkey/:userid/:uname/:device_token_id/:email/:name/:bio/:dob/:gender/:facebook/:twitter/:instagram/:show_social/:imagewidth/:imageheight',function(req,res,next){
    var _authkey = req.params.authkey;
    var _userid=req.params.userid;
    var _uname=req.params.uname;
    var _device_token_id = req.params.device_token_id;
    var _email = req.params.email;
    var _name = req.params.name;
    var _bio = req.params.bio;
    var _dob = req.params.dob;
    var _gender = req.params.gender;
    var _facebook = req.params.facebook;
    var _twitter = req.params.twitter;
    var _instagram = req.params.instagram;
    var _show_social = req.params.show_social;
    var _imagewidth = req.params.imagewidth;
    var _imageheight=req.params.imageheight;
    var _img_name="";

    if(_authkey != '') {
        if (_authkey == AUTH_KEY) {
            if (_device_token_id != '') {
                if(_email!='' ){
                    User.findOne({'_id':_userid},function(err,reslt){
                        if (reslt) {
                            User.findOne({'_id':_userid ,'email':_email},function(err,result){
                                if(result){
                                    appUser.LastID='';
                                    appUser.Ack=0;
                                    appUser.msg='Email already exist. Please use different email';
                                    res.send(appUser);
                                }
                                else
                                {
                                    User.findOne({'_id':_userid ,'username':_uname},function(err,result){
                                        if(result){
                                            appUser.LastID='';
                                            appUser.Ack=0;
                                            appUser.msg='Username already exist. Please choose different';
                                            res.send(appUser);
                                        }
                                      });
                                        if(req.files.profile_picture===undefined)
                                         {
                                            _img_name='';
                                            
                                         }
                                         else
                                         {
                                            _img_name=req.files.profile_picture.name;
                                          
                                          }
                                            User.update({ '_id': _userid },{'username':_uname,'email':_email,'name':_name,'bio':_bio,'gender':_gender,'dob':_dob,'image':_img_name,'imagewidth':_imagewidth,'imageheight':_imageheight,'facebook':_facebook,'twitter':_twitter,'instagram':_instagram,'is_social_show':_show_social},function(err,data){
                                                User.findOne({'_id':_userid },function(err,usr){
                                                  console.log(_userid);
                                                  console.log(usr);
                                                    appUser.LastID=_userid;
                                                    appUser.Ack=1;
                                                    appUser.UserDetails=({ id:{"$id":_userid},"username":usr.username,"email":usr.email,"name":usr.name,"bio":usr.bio,"gender":usr.gender,"dob":usr.dob,"image":usr.image,"imagewidth":usr.imagewidth,"imageheight":usr.imageheight,"facebook":usr.facebook,"twitter":usr.twitter,"instagram":usr.instagram,"is_social_show":usr.is_social_show,"latitude":usr.latitude,"longitude":usr.longitude,"registration_date":usr.registration_date,"last_logged_in":usr.last_logged_in})
                                                    appUser.msg='Your profile has been edited successfully';
                                                    res.send(appUser);
                                                });
                                            });
                                      }
                                                           
                                    });
                                }    
                                else
                                {
                                    appUser.LastID='';
                                    appUser.Ack=0;
                                    appUser.userdetail="";
                                    appUser.msg='Invalid user';
                                    res.send(appUser); 
                                }
                   });
                   
                }
                else
                {
                    appUser.LastID='';
                    appUser.Ack=0;
                    appUser.userdetail="";
                    appUser.msg='Please provide email address';
                    res.send(appUser); 
                }
            }
            else
            {
                appUser.LastID='';
                appUser.Ack=0;
                appUser.userdetail="";
                appUser.msg='Please provide device token';
                res.send(appUser); 
            }
        }
        else
        {
            appUser.LastID='';
            appUser.Ack=0;
            appUser.userdetail="";
            appUser.msg='Invalid auth key';
            res.send(appUser); 
        }
    }
    else
    {
        appUser.LastID='';
        appUser.Ack=0;
        appUser.userdetail="";
        appUser.msg='Please provide auth key';
        res.send(appUser); 
    }
});



module.exports = router;

var express = require('express');
var router = express.Router();
var mongoose = require('mongoose');

var moment = require('moment');
var User = require('../models/appmembermodel');
var UserSetting=require('../models/appusersettingmodel');
var appUser=require('../models/appusers');
var yabapps=require('../models/yabappmodel')
var UsrSettings=require('../models/usersettings');
var appyabcomment=require('../models/appyabcommentmodel');
var UserProfile=require('../models/userprofile');
var member=require('../models/membermodel');
var business=require('../models/businessmodel');
var yablikes=require('../models/appyablikemodel');
var AUTH_KEY = 'acea920f7412b7Ya7be0cfl2b8c937Bc9';
var md5 = require('MD5');


var yabcommentcount;
var yablikescount;


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

router.post('/postyab',function(req,res,next){
    var _authkey = req.body.authkey;
    var _userid=req.body.userid;
    var _device_token_id = req.body.device_token_id;
    var _message = req.body.message;
    var _target_group=req.body.target_group;
    var _broadcasting_radius = req.body.broadcasting_radius;
    var _min_age = req.body.min_age;
    var _max_age=req.body.max_age;
    var _exp = req.body.exp;
    var _location = req.body.location;
    var _imagewidth=req.body.imagewidth;
    var _imageheight = req.body.imageheight;
    var _lat = req.body.lat;
    var _long=req.body.long;
    var _yab_from = 'A';
    var _optionsyabfor = 'UA';
    var _business_id=req.body.business_id;
    var _push_noti = '0';
    var _yabimg = '';
    var _ip_address="";
    var date = new Date();
    var post_date = moment(date).format('YYYY-MM-DD H:mm:ss');

    if (_authkey != '') {
        if (_authkey == AUTH_KEY) {
            if (_device_token_id != '') {
                 User.findOne({'_id':_userid},function(err,item){
                  if(item)
                  {

                    if(req.files.profile_picture===undefined)
                     {
                        yab_img='';
                        
                     }
                     else
                     {
                        yab_img=req.files.profile_picture.name;
 
                     }
                     if ((_location) && _location!="")
                     {
                        _ip_address="";
                     }
                     else
                     {
                        _ip_address="";
                     }

                      var yab=new yabapps({'user_id':_userid,'business_id':_business_id,'message':_message,'location' :_location,'user_ip' :_ip_address, 'latitude':_lat,'longitude':_long, 'min_age': _min_age,'max_age':_max_age,'yab_for':_target_group,'broadcast_radius':_broadcasting_radius,'image':_yabimg,'imagewidth':_imagewidth,'imageheight':_imageheight,'expiration_date':_exp,'post_date':post_date,'yab_from':_yab_from,'yab_send_to':_optionsyabfor,'push_notification':_push_noti,'total_comment':0,'total_like':0});
                      yab.save(function(err,data){
                        
                        console.log("data");
                        console.log(data);
                        yabapps.findOne({'_id':data._id},function(err,result){

                          appUser.LastID=result._id;
                          appUser.Ack=1;
                          appUser.YabDetails=({ "id": result._id,"user_id": result.user_id,"message": result.text,"location": result.imageexist,'min_age':result.min_age,'max_age':result.max_age,'yab_for':result.yab_for,'broadcast_radius':result.broadcast_radius,'image':result.image,'imagewidth':result.imagewidth,'imageheight':result.imageheight,'expiration_date':result.expiration_date,'post_date':result.post_date});
                          appUser.msg='Your yab has been posted successfully';
                          res.send(appUser);
                        });
                      });
                  }
                  else
                  {
                    appUser.LastID='';
                    appUser.Ack=0;
                    appUser.YabDetails='';
                    appUser.msg='Invalid user';
                    res.send(appUser);
                  }
                 });
               }
               else
               {
                appUser.LastID='';
                appUser.Ack=0;
                appUser.YabDetails='';
                appUser.msg='Please provide device token';
                res.send(appUser);
               }
             }
             else
             {
              appUser.LastID='';
              appUser.Ack=0;
              appUser.YabDetails='';
              appUser.msg='Invalid auth key';
              res.send(appUser);
             }
           }
           else
           {
            appUser.LastID='';
            appUser.Ack=0;
            appUser.YabDetails='';
            appUser.msg='Please provide auth key';
            res.send(appUser);
           }

});

function time_elapsed_string(post_date){
  var date=post_date;
                              
  var currentTime=new Date();
  var sec,hours,minute,day,week,month,year;

  var curr=currentTime.getTime();
  var sub=(curr-date);
  if (sub<0) 
  {
      timeelapsed=0;
  }
  else
  {

    sec=(sub/1000);
    
      if (sec<0) 
      {
          timeelapsed=0+" sec ago";
      }
      else if (sec>0 && sec<60) 
      {
          if (Math.floor(sec)==1) 
          {
              timeelapsed= Math.floor(sec)+" sec ago";
          }
          else
          {
            timeelapsed= Math.floor(sec)+" secs ago";
          }
          
      }
      else 
      {
        minute=sec/60;
        if (minute>0 &&  minute<60) 
          {
              if (Math.floor(minute)==1) 
              {
                  timeelapsed= Math.floor(minute)+ " minute ago";
              }
              else
              {
                  timeelapsed= Math.floor(minute)+ " minutes ago";
              }
              
          }
          else
          {
            hours=minute/60;
            
            if(hours>0 && hours<24) 
            {
                if (Math.floor(hours)==1) 
                {
                    timeelapsed= Math.floor(hours)+ " hour ago";
                }
                else
                {
                    timeelapsed= Math.floor(hours)+ " hours ago";
                }
                
            }

            else
            {
              day=hours/24;
              
              if (day>0 && day<30) 
              {
                  if (Math.floor(day)==1) 
                  {
                      timeelapsed= Math.floor(day)+ " day ago";
                  }
                  else
                  {
                      timeelapsed= Math.floor(day)+ " days ago";
                  }
                  
              }
              else
              {
                  month=day/30;
                  
                  if (month>0 && month<12) 
                  {
                      if (Math.floor(month)==1) 
                      {
                          timeelapsed= Math.floor(month)+ " Month ago";
                      }
                      else
                      {
                          timeelapsed= Math.floor(month)+ " Months ago";
                      }
                    
                  }
                  else
                  {
                    year=month/12;
                    
                    if (Math.floor(year)==1) 
                    {
                        timeelapsed= Math.floor(year)+" year ago";
                    }
                    else
                    {
                        timeelapsed= Math.floor(year)+" years ago";
                    }
                  }
              }

            }

          }
      }
  }
  return timeelapsed;
}


router.get('/myyabs/:authkey/:userid/:device_token_id',function(req,res,next){
  var _authkey = req.params.authkey;
  var _userid=req.params.userid;
  var _device_token_id = req.params.device_token_id;
  var yabexist;
  var yabcount;
  var yablist=[];
  var all_yabs_short=[];
  var all_yabs=[];
  var data;
  var businessarr=[];
  var timeelapsed;
  if (_authkey != '') {
        if (_authkey == AUTH_KEY) {
            if (_device_token_id != '') {
              User.findOne({'_id':_userid},function(err,item){
                
                  if(item)
                  {
                    yabapps.find({'user_id':_userid}).sort({post_date: -1}).exec(function(err,yabs){
                      
                      
                        yabexist=1;
                        yabcount=yabs.length;
                            if (yabcount>0) 
                            {
                              var uid=_userid;
                              var Ack=1;
                            appUser.id=uid;
                            appUser.Ack=Ack;
                            appUser.totalyabs=yabcount;
                            for (var y in yabs) {
                              var date = new Date(yabs[y].post_date);
                              var post_date = moment(date).format('DD-MM-YYYY, H:mm');
                              var yabshortdetail,yabdetails,imageexist;
                              var total_like, total_comment;
                              var t= date.getTime();
                              
                              var timeelapsed=time_elapsed_string(t);

                              if(yabs[y].total_like==undefined)
                              {
                                  total_like=0;
                              }
                              else
                              {
                                  total_like=yabs[y].total_like;
                              }

                              if (yabs[y].total_comment==undefined) 
                              {
                                  total_comment=0;
                              }
                              else
                              {
                                  total_comment=yabs[y].total_comment;
                              }

                              yabdetails=({"id":yabs[y]._id,"post_date": post_date,'post_time_ago':timeelapsed,"message": yabs[y].message,'username':item.username,"image":yabs[y].image,"img":item.image,'imagewidth':yabs[y].imagewidth,'imageheight':yabs[y].imageheight,'broadcast_radius':yabs[y].broadcast_radius,'total_like':total_like,'total_comment':total_comment})
                              console.log(yabdetails);
                              all_yabs.push(yabdetails);
                            }
                              appUser.yablist=all_yabs;
                              var msg='Your posted yabs listing';
                              appUser.msg=msg;
                              res.send(appUser);
                            }
                            else
                            {
                                appUser.id = $userid;
                                appUser.Ack = 1;
                                appUser.msg = 'You have not posted any yab yet';
                                res.send(appUser);
                            }
                      });
                  }
                      else
                      {
                        member.findOne({'_id':_userid},function(err,item){
                            business.find({'_id':item.business_id},function(err,busi){
                              yabapps.find({'user_id':_userid}).sort({post_date: -1}).exec(function(err,yabs){
                                if (yabs) 
                                {
                                    yabcount=yabs.length;
                                    if (yabcount>0) 
                                      {
                                        appUser.id=_userid;
                                        appUser.Ack=1;
                                        appUser.totalyabs=yabcount;
                                        for (var y in yabs) {
                                          var date = new Date(yabs[y].post_date);
                                          var post_date = moment(date).format('DD-MM-YYYY, H:mm');
                                          var yabshortdetail,yabdetails,imageexist;
                                          var t= date.getTime();
                              
                              
                                          var timeelapsed=time_elapsed_string(t);
                                          if(yabs[y].total_like==undefined)
                                          {
                                              total_like=0;
                                          }
                                          else
                                          {
                                              total_like=yabs[y].total_like;
                                          }

                                          if (yabs[y].total_comment==undefined) 
                                          {
                                              total_comment=0;
                                          }
                                          else
                                          {
                                              total_comment=yabs[y].total_comment;
                                          }
                                          yabdetails=({"id":yabs[y]._id,"post_date": post_date,'post_time_ago':timeelapsed,"message": yabs[y].message,'username':item.username,"image":yabs[y].image,"img":item.image,'imagewidth':yabs[y].imagewidth,'imageheight':yabs[y].imageheight,'broadcast_radius':yabs[y].broadcast_radius,'total_like':total_like,'total_comment':total_comment})
                                          all_yabs.push(yabdetails);
                                        }
                                          appUser.yabslist=all_yabs;
                                          appUser.msg='Your posted yabs listing';
                                          res.send(appUser);
                                      }

                                      else
                                      {
                                          appUser.id = $userid;
                                          appUser.Ack = 1;
                                          appUser.msg = 'You have not posted any yab yet';
                                          res.send(appUser);
                                      }

                                }

                                else
                                  {
                                      appUser.id = '';
                                      appUser.Ack = 0;
                                      appUser.msg = 'Invalid user';
                                      res.send(appUser);
                                  }

                            });
                        });
                      });
                      
                    }

                  
                  });
                }
                else
                {
                    appUser.id = '';
                    appUser.Ack = 0;
                    appUser.msg = 'Please provide device token';
                    res.send(appUser);
                }
            
          }
          else
          {
            appUser.id = '';
            appUser.Ack = 0;
            appUser.msg = 'Invalid auth key';
            res.send(appUser);
          }
        }
        else
        {
          appUser.id = '';
          appUser.Ack = 0;
          appUser.msg = 'Please provide auth key';
          res.send(appUser);
        }


});

router.get('/mywebyabs/:userid/:businessid',function(req,res,next){
    var userid = req.params.userid;
    var businessid=req.params.businessid;
    var yabexist;
    var all_yabs_short=[];
    var all_yabs=[];
    var data=[];
    var businessarr=[];
    yabapps.find({'user_id':userid}).sort({post_date: -1}).exec(function(err,yabs){
     if(yabs)
     {
       yabexist=1;
       for(var y in yabs)
       {
            var yabshortdetail,yabdetail,imageexist;
            
            var date = new Date(yabs[y].post_date);
            var post_date = moment(date).format('DD-MM-YYYY, H:mm');
            
            var yabtext=yabs[y].message;
            var yabtext1=yabtext.replace(/(?:http:\/\/)?(?:www\.)?(?:youtube\.com|youtu\.be)\/(?:watch\?v=)?(.+)/g, '<iframe width="380" height="250" src="http://www.youtube.com/embed/$1" frameborder="0" allowfullscreen style="margin-bottom:20px;margin-left:0px;margin-top:20px;"></iframe>');
            var text=yabtext.substr(0, 45)+'...';
            
            var image=yabs[y].image;
            if(image=='')
            {
              imageexist=0;
            }
            else
            {
              imageexist=1;
            }
            
            
            yabshortdetail = ({ "id": yabs[y]._id,"post_date": post_date,"message": text,"imageexist": imageexist});
            yabdetail = ({ "id": yabs[y]._id,'businessid':yabs[y].business_id,"post_date": post_date,"message": yabtext,"image":image,"imageexist": imageexist,'total_like':yabs[y].total_like,'total_comment':yabs[y].total_comment});
            all_yabs_short.push(yabshortdetail);
            all_yabs.push(yabdetail);
       }
     }
     else
     {
       yabexist=0;
     }
     business.findOne({'_id':businessid},function(err,businesses){
      businessarr.push(businesses);
       data[0]=yabexist;
       data[1]=all_yabs_short;
       data[2]=all_yabs;
       data[3]=businessarr;
       res.send(data);
     });
    });
});

router.post('/webpostyab',function(req,res,next){
    var _optionsyabfor = req.body.optionsyabfor;
    var _userid = req.body.userid;
    var _message = req.body.message; 
    var _optionsRadios = req.body.optionsRadios;
    var _broadcasting_radius = req.body.broadcasting_radius;
    var _min_age = req.body.min_age;
    var _max_age = req.body.max_age;
    var _exp_radio = req.body.exp_radio;
    var _exp = req.body.exp;
    var _push_noti = req.body.push_noti;
    var yab_from = 'W';
    var optionsyabfor,image,push_noti,exp_date,imagewidth,imageheight;
    
    
    if(_optionsyabfor===undefined)
    {
      optionsyabfor='UA';
    }
    else if(_optionsyabfor!='')
    {
      optionsyabfor=_optionsyabfor;
    }
    else
    {
      optionsyabfor='UA';
    }
    
    if(_push_noti=='')
    {
      push_noti=0;
    }
    else if(_push_noti==1)
    {
       push_noti=1;
    }
    else
    {
      push_noti=0;
    }
    
    if(_exp_radio==1)
    {
       exp_date=_exp;
    }
    else
    {
       exp_date='';
    }
    
    if(req.files.profile_picture===undefined)
    {
       image='';
       imagewidth='';
       imageheight='';
    }
    else
    {
       image=req.files.profile_picture.name;
       imagewidth=req.body.imagewidth;
       imageheight=req.body.imageheight;
    }
    
    
    var businessid=req.session.user.business_id;
    var latitude=req.session.user.latitude;
    var longitude=req.session.user.longitude;
    var today = getToday();
    var lastWeek = getLastWeek();
    var lastMonth = getLastMonth();
    var lastYear = getLastYear();
    
   business.findOne({'_id':businessid},function(err,businesses){
          var yabperweek=businesses.yabperweek;
          var yabpermonth=businesses.yabpermonth;
          var yabperyear=businesses.yabperyear;
          var yabperweekleft,yabpermonthleft,yabperyearleft;
          var weekcount=0,monthcount=0,yearcount=0;
          
          yabapps.find({'business_id':businessid},function(err,yabs){
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
            }
            else
            {
            }
            
            if(yearcount < yabperyear)
            {
             if(monthcount < yabpermonth)
             {
              if(weekcount < yabperweek)
              {
                  var date = new Date();
                  var post_date = moment(date).format('YYYY-MM-DD H:mm:ss');
            
                  var _yab=new yabapps({'user_id':_userid,'business_id':businessid,'message':_message,'user_ip':'','latitude':latitude,'longitude':longitude,'min_age':_min_age,'max_age':_max_age,'yab_for':_optionsRadios,'yab_send_to':optionsyabfor,'push_notification':push_noti,'broadcast_radius':_broadcasting_radius,'image':image,'imagewidth':imagewidth,'imageheight':imageheight,'expiration_date':exp_date,'post_date':post_date,'yab_from':yab_from,'total_comment':0,'total_like':0});
                  _yab.save(function(err) {
                          if (err) res.redirect("/yabs/post");
                  });
                  res.redirect("/yabs/myyabs");
              }
             }
            }
          });
     });
});

router.get('/deletemyyab/:id', function(req, res, next) {
  var id = req.params.id;
  yabapps.findOne({"_id":id},function(err,yabfind){
        if (err) {
           res.send('error');
        }
        else if(yabfind=='' || yabfind==null)
        {
           res.send('error');
        }
        else 
        {
          yabapps.remove({ '_id': id },function(err,yabremove){
          });
          appyabcomment.remove({ 'yab_id': id },function(err,commentremove){
          });
          yablikes.remove({ 'yab_id': id },function(err,likeremove){
          });
          res.send('success');
        }
   });
});

module.exports = router;

var express = require('express');
var mongoose = require('mongoose');
var Member = require('../models/membermodel');
var Business = require('../models/businessmodel');
var router = express.Router();
var session = require('express-session');
var md5 = require('MD5');
var html = require('html');
var moment = require('moment');

/* Member List Page */
router.get('/', function(req, res) {
    var member_exist=0;
    var all_members=[];
    var all_businesses=[];
    var data=[];
     Member.find({},function(err,members){
      if(members)
      {
        member_exist=1;
        for(var m in members)
        {
            var userdetail;
            userdetail = ({ "id": members[m]._id,'business_id': members[m].business_id,"email": members[m].email,"is_business_admin": members[m].is_business_admin,"is_active": members[m].is_active,"registration_date": members[m].registration_date});
            all_members.push(userdetail);
        }
      }
      else
      {
       member_exist=0;
      }
      Business.find({},function(err,businesses){
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
        data[0]=member_exist;
        data[1]=all_members;
        data[2]=all_businesses;
        res.send(data);
      });
   });
});

router.get('/mymembers/:businessid/:id', function(req, res) {
    var member_exist=0;
    var all_members=[];
    var all_businesses=[];
    var data=[];
    var businessid = req.params.businessid;
    var id = req.params.id;
     Member.find({'_id':{$ne:id},'business_id':businessid},function(err,members){
      if(members)
      {
        member_exist=1;
        for(var m in members)
        {
            var userdetail;
            userdetail = ({ "id": members[m]._id,'business_id': members[m].business_id,"email": members[m].email,"is_business_admin": members[m].is_business_admin,"is_active": members[m].is_active,"registration_date": members[m].registration_date});
            all_members.push(userdetail);
        }
      }
      else
      {
       member_exist=0;
      }
      Business.find({},function(err,businesses){
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
        data[0]=member_exist;
        data[1]=all_members;
        data[2]=all_businesses;
        res.send(data);
      });
   });
});

router.get('/login/:email/:password/:latitude/:longitude', function(req, res, next) {
 var _email = req.params.email;
 var _password = md5(req.params.password); 
 var _ulatitude = req.params.latitude;
 var _ulongitude = req.params.longitude;
 Member.findOne({"email":_email,"password":_password},function(err,user){
        if (err) {
           res.send('error');
        }
        else if(user=='' || user==null)
        {
           res.send('error');
        }
        else 
        {
           if(_ulatitude!='' && _ulongitude!='')
           {
             Member.update({ '_id': user._id }, { $set: {'latitude': _ulatitude,'longitude': _ulongitude}}, function (err, doc) {
                  if (err) {
                    res.send('error');
                  }                 
             });
           }
            res.send(user);
        }
    });
});

router.post('/add', function(req, res) {
  var uname = req.body.uname;
  var businessid = req.body.username; 
  var email = req.body.email;
  var password = req.body.password;
  var isbusinessadmin = req.body.is_business_admin;
  var isactive = req.body.is_active;
  var is_active,is_business_admin,userassociated,membernumber;
  if(isactive==1)
  {
    is_active=1;
  }
  else
  {
    is_active=0;
  }

  if(isbusinessadmin==1)
  {
    is_business_admin=1;
  }
  else
  {
    is_business_admin=0;
  }
  
  
    Member.findOne({"email":email},function(err,memberfind){
     if(memberfind=='' || memberfind==null)
     {
            Business.findOne({"_id":businessid},function(err,businessfind){
             if(businessfind)
             {
                 userassociated=businessfind.userperaccount;
                  
             }
            Member.find({"business_id":businessid},function(err,membercount){ 
             if(membercount)
             {
               membernumber=membercount.length;
             }
             else
             {
               membernumber=0;
             }
             
             if(membernumber < userassociated)
             {
               var date = new Date();
               var registration_date = moment(date).format('YYYY-MM-DD');
               var _member=new Member({'business_id':businessid,'name':uname,'email':email,'password' : md5(password),'is_business_admin':is_business_admin,'latitude':'','longitude':'','registration_date':registration_date,'is_active':is_active});
              _member.save(function(err) {
                  if (err) res.send('error');
                  Business.findOne({'_id':businessid},function(err,businss){
                     var memberassociate=businss.total_member;
                     memberassociate=memberassociate+1;
                       Business.update({ '_id': businessid }, { $set: {'total_member':memberassociate}}, function (err, doc) {
                           if (err) {
                             
                            }                 
                       });
                  });
               });
              res.send('success');
             }
             else
             {
               res.send('limitexceed');
             }
            }); 
         });
     }
     else
      {
         res.send('memberexist');
      }
    });
});

router.post('/memberadd', function(req, res) {
  var uname = req.body.uname;
  var businessid = req.body.username; 
  var email = req.body.email;
  var password = req.body.password;
  var userassociated,membernumber;
  
    Member.findOne({"email":email},function(err,memberfind){
     if(memberfind=='' || memberfind==null)
     {
            Business.findOne({"_id":businessid},function(err,businessfind){
             if(businessfind)
             {
                 userassociated=businessfind.userperaccount;
                  
             }
            Member.find({"business_id":businessid},function(err,membercount){ 
             if(membercount)
             {
               membernumber=membercount.length;
             }
             else
             {
               membernumber=0;
             }
             
             if(membernumber < userassociated)
             {
               var date = new Date();
               var registration_date = moment(date).format('YYYY-MM-DD');
               var _member=new Member({'business_id':businessid,'name':uname,'email':email,'password' : md5(password),'latitude':'','longitude':'','registration_date':registration_date,'is_active':1});
              _member.save(function(err) {
                  if (err) res.send('error');
                  Business.findOne({'_id':businessid},function(err,businss){
                     var memberassociate=businss.total_member;
                     memberassociate=memberassociate+1;
                       Business.update({ '_id': businessid }, { $set: {'total_member':memberassociate}}, function (err, doc) {
                           if (err) {
                             
                            }                 
                       });
                  });
               });
              res.send('success');
             }
             else
             {
               res.send('limitexceed');
             }
            }); 
         });
     }
     else
      {
         res.send('memberexist');
      }
    });
});

router.get('/delete/:id', function(req, res) {
    var id = req.params.id;
     Member.findOne({"_id":id},function(err,memberfind){
        if (err) {
           res.send('error');
        }
        else if(memberfind=='' || memberfind==null)
        {
           res.send('error');
        }
        else 
        {
          Member.remove({ '_id': id },function(err,memberremove){
            res.send('success');
          });
        }
     });
});

router.get('/active/:id', function(req, res) {
    var id = req.params.id;
     Member.findOne({"_id":id},function(err,memberfind){
        if (err) {
           res.send('error');
        }
        else if(memberfind=='' || memberfind==null)
        {
           res.send('error');
        }
        else 
        {
          Member.update({ '_id': id }, { $set: {'is_active': 1}}, function (err, memberactive) {
            res.send('success');
          });
        }
     });
});

router.get('/deactive/:id', function(req, res) {
    var id = req.params.id;
     Member.findOne({"_id":id},function(err,memberfind){
        if (err) {
           res.send('error');
        }
        else if(memberfind=='' || memberfind==null)
        {
           res.send('error');
        }
        else 
        {
          Member.update({ '_id': id }, { $set: {'is_active': 0}}, function (err, memberdeactive) {
            res.send('success');
          });
        }
     });
});

router.get('/view/:id', function(req, res) {
    var id = req.params.id;
    var data=[];
      Member.findOne({"_id":id},function(err,memberview){
        if (err) {
           res.send('error');
        }
        else if(memberview=='' || memberview==null)
        {
           res.send('error');
        }
        else 
        {
           Business.findOne({"_id":memberview.business_id},function(err,business){
             data[0]=memberview;
             data[1]=business;
             res.send(data);
          });
        }
     });
});

router.get('/edit/:id', function(req, res) {
    var id = req.params.id;
    var all_businesses=[];
    var data=[];
     Member.findOne({"_id":id},function(err,memberfind){
        if (err) {
           res.send('error');
        }
        else if(memberfind=='' || memberfind==null)
        {
           res.send('error');
        }
        else 
        {
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
           data[0]=memberfind;
           data[1]=all_businesses;
           res.send(data);
          });
        }
     });
});

router.get('/memberedit/:id/:businessid', function(req, res) {
    var id = req.params.id;
    var businessid = req.params.businessid;
    var all_businesses=[];
    var data=[];
     Member.findOne({"_id":id},function(err,memberfind){
        if (err) {
           res.send('error');
        }
        else if(memberfind=='' || memberfind==null)
        {
           res.send('error');
        }
        else 
        {
          Business.find({'_id':businessid,'is_active':1},function(err,businesses){
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
           data[0]=memberfind;
           data[1]=all_businesses;
           res.send(data);
          });
        }
     });
});


router.post('/postedit', function(req, res) {
  var uname = req.body.uname;
  var businessid = req.body.username; 
  var email = req.body.email;
  var password = req.body.password;
  var isbusinessadmin = req.body.is_business_admin;
  var isactive = req.body.is_active;
  var memberid = req.body.userid; 
  var is_active,is_business_admin,userassociated,membernumber,passwrd;

  if(isactive==1)
  {
    is_active=1;
  }
  else
  {
    is_active=0;
  }

  if(isbusinessadmin==1)
  {
    is_business_admin=1;
  }
  else
  {
    is_business_admin=0;
  }
  
    Member.findOne({"_id":memberid},function(err,memberfind){
        if (err) {
           res.send('error');
        }
        else if(memberfind=='' || memberfind==null)
        {
           res.send('error');
        }
        else 
        {
          Member.findOne( {'_id':{$ne:memberid},"email": email},function(err,membr){
             if(membr=='' || membr==null)
             {
                Business.findOne({"_id":businessid},function(err,businessfind){
                if(businessfind)
                {
                   userassociated=businessfind.userperaccount;
                }
                Member.find({'_id':{$ne:memberid},"business_id":businessid},function(err,membercount){ 
                if(membercount)
                {
                  membernumber=membercount.length;
                }
                else
                {
                  membernumber=0;
                }
                if(membernumber < userassociated)
                {
                  if(password!='')
	          {
	             passwrd=md5(password);
	          }
	          else
	          {
	            passwrd=memberfind.password;
	          }
                  Member.update({ '_id': memberid }, { $set: {'business_id':businessid,'name':uname,'email':email,'password' : passwrd,'is_business_admin':is_business_admin,'is_active':is_active}}, function (err, doc) {
                   if (err) {
                     res.send('error');
                    }
                  });
                  res.send('success');
                }
                else
                {
                  res.send('limitexceed');
                }
               });
              });
             }
             else
             {
                res.send('memberexist');
             }
          });
        }
     });
});

router.post('/memberpostedit', function(req, res) {
  var uname = req.body.uname;
  var businessid = req.body.username; 
  var email = req.body.email;
  var password = req.body.password;
  var memberid = req.body.userid; 
  var userassociated,membernumber,passwrd;
  
    Member.findOne({"_id":memberid},function(err,memberfind){
        if (err) {
           res.send('error');
        }
        else if(memberfind=='' || memberfind==null)
        {
           res.send('error');
        }
        else 
        {
          Member.findOne( {'_id':{$ne:memberid},"email": email},function(err,membr){
             if(membr=='' || membr==null)
             {
                Business.findOne({"_id":businessid},function(err,businessfind){
                if(businessfind)
                {
                   userassociated=businessfind.userperaccount;
                }
                Member.find({'_id':{$ne:memberid},"business_id":businessid},function(err,membercount){ 
                if(membercount)
                {
                  membernumber=membercount.length;
                }
                else
                {
                  membernumber=0;
                }
                if(membernumber < userassociated)
                {
                  if(password!='')
	          {
	             passwrd=md5(password);
	          }
	          else
	          {
	            passwrd=memberfind.password;
	          }
                  Member.update({ '_id': memberid }, { $set: {'business_id':businessid,'name':uname,'email':email,'password' : passwrd}}, function (err, doc) {
                   if (err) {
                     res.send('error');
                    }                 
                  });
                  res.send('success');
                }
                else
                {
                  res.send('limitexceed');
                }
               });
              });
             }
             else
             {
                res.send('memberexist');
             }
          });
        }
     });
});

router.post('/editprofile', function(req, res, next) {
 var userid = req.body.userid;
 var name = req.body.uname;
 var email = req.body.email;
  Member.findOne({"_id":userid},function(err,memberfind){
  if (err) {
   res.send('error');
  }
  else if(memberfind=='' || memberfind==null)
  {
    res.send('error');
  }
  else 
  { 
       Member.findOne( {'_id':{$ne:userid},"email": email},function(err,membr){
       if(membr=='' || membr==null)
       {
            Member.update({ '_id': userid }, { $set: {'name': name,'email':email}}, function (err, doc) {
            if (err) {
                    res.send('error');
             }
             else
             {
                    req.session.user.name = name;
                    req.session.user.email = email;
                    res.send('success');
             }                
           });
        }
        else
        {
            res.send('memberexist');
        }
      });
   }
 });
});

router.post('/changepassword', function(req, res, next) {
 var userid = req.body.userid;
 var cpassword = req.body.cpassword;
 var npassword = req.body.npassword;
  Member.findOne({"_id":userid},function(err,memberfind){
  if (err) {
   res.send('error');
  }
  else if(memberfind=='' || memberfind==null)
  {
    res.send('error');
  }
  else 
  { 
       Member.findOne( {'_id':userid,"password": md5(cpassword)},function(err,membr){
       if(membr=='' || membr==null)
       {
            res.send('passerror');
        }
        else
        {
            Member.update({ '_id': userid }, { $set: {'password': md5(npassword)}}, function (err, doc) {
            if (err) {
                    res.send('error');
             }
             else
             {
                    res.send('success');
             }                
           });
        }
      });
   }
 });
});

module.exports = router;

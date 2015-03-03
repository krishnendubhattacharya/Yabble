var express = require('express');
var mongoose = require('mongoose');
var Admin = require('../models/adminmodel');
var router = express.Router();
var session = require('express-session');
var md5 = require('MD5');


/* Admin Login */
router.get('/login/:email/:password/:latitude/:longitude', function(req, res, next) {
 var _email = req.params.email;
 var _password = md5(req.params.password); 
 var _ulatitude = req.params.latitude;
 var _ulongitude = req.params.longitude;
 Admin.findOne({"email":_email,"password":_password},function(err,user){
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
             Admin.update({ '_id': user._id }, { $set: {'latitude': _ulatitude,'longitude': _ulongitude}}, function (err, doc) {
                  if (err) {
                    res.send('error');
                  }                 
             });
           }
            res.send(user);
        }
    });
});

router.get('/editprofile/:id', function(req, res, next) {
 var id = req.params.id;
 Admin.findOne({"_id":id},function(err,user){
        if (err) {
           res.send('error');
        }
        else if(user=='' || user==null)
        {
           res.send('error');
        }
        else 
        {
          res.send(user);
        }
   });
});

router.post('/posteditprofile', function(req, res, next) {
 var userid = req.body.adminid;
 var first_name = req.body.first_name;
 var last_name = req.body.last_name; 
 var email = req.body.email;
 var password = req.body.password;
 var phone = req.body.phone;
 var paypal_email = req.body.paypal_email;
 
  if(password!='')
  {
       Admin.update({ '_id': userid }, { $set: {'first_name': first_name,'last_name': last_name,'email':email,'password':md5(password),'phone':phone,'paypal_email':paypal_email}}, function (err, doc) {
                  if (err) {
                    res.send('error');
                  }
                  else
                  {
                    req.session.user.first_name = first_name;
                    req.session.user.email = email;
                    res.send('success');
                  }                
       });
  }
  else
  {
        Admin.update({ '_id': userid }, { $set: {'first_name': first_name,'last_name': last_name,'email':email,'phone':phone,'paypal_email':paypal_email}}, function (err, doc) {
                  if (err) {
                    res.send('error');
                  }  
                  else
                  {
                    req.session.user.first_name = first_name;
                    req.session.user.email = email;
                    res.send('success');
                  }               
        });
   }
});

module.exports = router;

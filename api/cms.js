var express = require('express');
var mongoose = require('mongoose');
var Cms = require('../models/cmsmodel');
var router = express.Router();
var session = require('express-session');
var md5 = require('MD5');


router.get('/', function(req, res, next) {
    var all_cms=[];
    var data=[];
    var cms_exist=0;
    Cms.find({},function(err,cmses){
      if(cmses)
      {
             cms_exist=1;
             for(var c in cmses)
             {
                    var cms;
                    cms = ({ "id": cmses[c]._id,'pagename': cmses[c].pagename,"pageheading": cmses[c].pageheading});
                    all_cms.push(cms);
             }
       }
       else
       {
            cms_exist=0;
       }
       
       data[0]=cms_exist;
       data[1]=all_cms;
       res.send(data);
    });
});

router.post('/add', function(req, res, next) {
 var pagename = req.body.pagname;
 var pageheading = req.body.pagheading; 
 var content = req.body.contnt;
 
  Cms.findOne({"pagename":pagename},function(err,cms){
    if(cms=='' || cms==null)
    {
         var _cms=new Cms({'pagename':pagename,'pageheading':pageheading,'content':content});
         _cms.save(function(err) {
                if (err) res.send('error');
          });
          res.send('success');
     }
     else
     {
        res.send('cmsexist');
     }
  });
});

router.get('/view/:id', function(req, res, next) {
   var id = req.params.id;
    Cms.findOne({"_id":id},function(err,cms){
        if (err) {
           res.send('error');
        }
        else if(cms=='' || cms==null)
        {
           res.send('error');
        }
        else 
        {
          res.send(cms);
        }
    });
});

router.get('/delete/:id', function(req, res, next) {
  var id = req.params.id;
  Cms.findOne({"_id":id},function(err,cms){
        if (err) {
           res.send('error');
        }
        else if(cms=='' || cms==null)
        {
           res.send('error');
        }
        else 
        {
          Cms.remove({ '_id': id },function(err,cms){
            res.send('success');
          });
        }
    });
});

router.get('/edit/:id', function(req, res, next) {
  var id = req.params.id;
  Cms.findOne({"_id":id},function(err,cms){
        if (err) {
           res.send('error');
        }
        else if(cms=='' || cms==null)
        {
           res.send('error');
        }
        else 
        {
          res.send(cms);
        }
  });
});  

router.post('/postedit', function(req, res, next) {
     var pagename = req.body.pagename;
     var pageheading = req.body.pageheading; 
     var content = req.body.contents;
     var id = req.body.contentid;
     
     Cms.findOne({"_id":id},function(err,cmsfind){
      if (err) {
           res.send('error');
      }
      else if(cmsfind=='' || cmsfind==null)
      {
           res.send('error');
      }
      else 
      {
        Cms.findOne( {'_id':{$ne:id},"pagename": pagename},function(err,cms){
         if(cms=='' || cms==null)
         {
           Cms.update({ '_id': id }, { $set: {'pagename': pagename,'pageheading': pageheading,'content':content}}, function (err, doc) {
                 if (err) {
                   res.send('error');
                 }                 
           });
           res.send('success');
         }
         else
         {
           res.send('cmsexist');
         }
      });
    }
  });
});

module.exports = router;

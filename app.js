var express = require('express');
var path = require('path');
var ejs = require('ejs');
var favicon = require('serve-favicon');
var logger = require('morgan');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var session = require('client-sessions');
var md5 = require('MD5');
var html = require('html');
var multer  = require('multer');


//var mongo = require('mongodb');
//var monk = require('monk');
//var db = monk('108.179.225.244:27017/yabble');
//var routes = require('./routes/index');
//var admin = require('./routes/admin/index');

/*=======================API Start================================*/
var yabapi=require('./api/yab');
var adminapi=require('./api/admin');
var cmsapi=require('./api/cms');
var businessprofileapi=require('./api/businessprofile');
var memberapi=require('./api/member');
var appmemberapi=require('./api/appmember');
/*=======================API End================================*/

var frontend = require('./controllers/indexcontroller');
var memberbusiness = require('./controllers/businesscontroller');
var mymember = require('./controllers/memberscontroller');
var yab = require('./controllers/yabscontroller');

var admin = require('./controllers/admin/indexcontroller');
var business = require('./controllers/admin/businesscontroller');
var member = require('./controllers/admin/memberscontroller');
var appmember = require('./controllers/admin/appmemberscontroller');
var cms = require('./controllers/admin/cmscontroller');
var dashboard = require('./controllers/admin/dashboardcontroller');

var app = express();

// view engine setup
app.set('views', require('path').join(__dirname, 'views'));  
app.engine('html', require('ejs').renderFile);  
app.set('view engine', 'html');

// uncomment after placing your favicon in /public
//app.use(favicon(__dirname + '/public/favicon.ico'));

app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded());
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use(multer({ dest: './public/member_image/',
 rename: function (fieldname, filename) {
    return filename+Date.now();
  },
onFileUploadStart: function (file) {
  console.log(file.originalname + ' is starting ...')
},
onFileUploadComplete: function (file) {
  console.log(file.fieldname + ' uploaded to  ' + file.path)
}
}));

app.use(session({
  cookieName: 'session',
  secret: 'random_string_goes_here',
  duration: 30 * 60 * 1000,
  activeDuration: 5 * 60 * 1000,
}));

// Make our db accessible to our router
/*app.use(function(req,res,next){
    req.db = db;
    next();
});*/

app.use('/api/yab',yabapi);
app.use('/api/admin',adminapi);
app.use('/api/cms',cmsapi);
app.use('/api/business',businessprofileapi);
app.use('/api/member',memberapi);
app.use('/api/appmember',appmemberapi);
/*=======================API End================================*/

app.use('/', frontend);
app.use('/business', memberbusiness);mymember
app.use('/members', mymember);
app.use('/yabs', yab);

app.use('/admin', admin);
app.use('/admin/business', business);
app.use('/admin/members', member);
app.use('/admin/appmembers', appmember);
app.use('/admin/cms', cms);
app.use('/admin/dashboard', dashboard);

/// catch 404 and forwarding to error handler
app.use(function(err,req, res, next) {
    res.status(404);
   // respond with html page
   if (req.accepts('html')) {
     res.render('404');
     return;
   }
});

// development error handler
// will print stacktrace
if (app.get('env') === 'development') {
    app.use(function(err, req, res, next) {
        res.status(err.status || 500);
        res.render('500', { error: err });
    });
}

// production error handler
// no stacktraces leaked to user
app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    res.render('500', { error: err });
});


module.exports = app;

const express = require("express");
const app = express();

const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const bodyParser = require("body-parser");
const MongoClient = require('mongodb').MongoClient;
const ObjectID = require('mongodb').ObjectID;
const url ='mongodb://toto:ucsdhack2018@ds050087.mlab.com:50087/trustme'

const secret ="toto";


app.use(bodyParser.urlencoded( { extended: false}));
app.use(bodyParser.json())

//app.use(libMiddlewares.Cors);







MongoClient.connect(url)
   .then(database => {
     users = database.db().collection("users");





       /*app.route('/session/:uuid')
          .patch(libSessions.sessionUpdateChecker,libSessions.updateSessionPosition)

          .get(libSessions.getSessionByUuid)


       app.route('/session')
          .post(libSessions.sessionChecker,libSessions.newSession)

          .get(libSessions.getSessions)

      app.post('/sportzonebysport/:sport',libSportzones.getSportzoneBySport)

      app.post('/sportzonebysport',libSportzones.getAllSportzonesSortByDistance)

       app.route('/sportzone/:id')
          .patch(libMiddlewares.verifyToken,libSportzones.updateSession)

          .delete(libMiddlewares.verifyToken,libSportzones.deleteSportzones)

          .get(libSportzones.getOneSportzone)

       //ne marchera pas
       app.post('/fileUpload/:id',libSportzones.up,libSportzones.image)

       app.get('/image/:id',libSportzones.getimage)

       app.route('/sportzone')
          .post(libMiddlewares.verifyToken,libSportzones.SportzoneChecker, libSportzones.postSportzone)

          //.get(libSportzones.getAllSportzonesSortByDistance)


       app.get('/myadminaccount',libMiddlewares.verifyToken, libAdmins.getAdminAccount)

       app.post('/loginadmin',libAdmins.adminChecker, libAdmins.loginAdmin )



       app.route('/admins')
         .post(libAdmins.adminChecker, libAdmins.createAdmin)

         .get(libAdmins.getAdmins)

         .delete( libAdmins.deleteAdmin)



*/
      app.listen(3000, () => console.log("Awaiting requests."));
   })
   .catch(err => {throw err });
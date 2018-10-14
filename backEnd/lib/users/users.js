const bcrypt = require('bcryptjs');
const MongoClient = require('mongodb').MongoClient;
const ObjectID = require('mongodb').ObjectID;
const jwt = require('jsonwebtoken');

const secret ="toto";

module.exports.userChecker = (req,res,next) => {
  const user = {
    mail: req.body.mail,
    passwd: req.body.passwd
  }
  for( let attr in user){
    if (user[attr] === undefined){
      return res.status(400).json({error: "Bad user parameters"})
    }
  }
  next();
}

module.exports.getUserRatio = (req,res) => {
  console.log(req.query.mail)
  users.findOne(
    { mail: req.query.mail },
    { fields:{passwd: 0 }}
  )
     .then(item => (item) ? res.json(item) : res.status(404).json({ error: "Entity not found." }))
     .catch(err => console.log("err" + err))
}

module.exports.getUserAccount = (req,res) => {
  users.findOne(
    { _id: ObjectID(req.userId) },
    { fields:{passwd: 0 }}
  )
     .then(item => (item) ? res.json(item) : res.status(404).json({ error: "Entity not found." }))
     .catch(err => console.log("err" + err))

}

module.exports.getUserName = (req,res, next) => {
    users.findOne(
      { _id: ObjectID(req.userId) },
      { fields:{passwd: 0 }}
    )
        .then( item => {
            req.username = item.mail;
            next();
        })
       .catch(err => console.log("err" + err))
  }


module.exports.loginUser = (req,res) => {
  users.findOne({ mail: req.body.mail} )
     .then( item => {
     if (!item) return res.status(404).json({ error: "Entity not found." })
     bcrypt.compare(req.body.passwd, item.passwd)
       .then( ress => {
         console.log(ress);
          if(!ress) return res.status(401).send({auth: false, token:null});
          let token = jwt.sign({ id: item._id }, secret, {
          expiresIn: 86400 // expires in 24 hours
          });
          res.status(201).send({auth: true, token :token});
       })
     })
}


module.exports.createUser =  (req,res) => {
            const user ={
              mail: req.body.mail,
              passwd: bcrypt.hashSync(req.body.passwd, 8),
              validAgreements: 0,
              unValidAgreements: 0
           }

           users.insert(user)
              .then(command => {
                res.status(201).send({create: true});
              })
              .catch((err) => {
                console.log("Error: " + err);
                res.send({error: 'Username already used'});//normaly a condition souhld check the err
              })
            }


/*module.exports.deleteAdmin =  (req,res) => {
            const admin = {
              mail: req.body.mail
           }
           console.log("coucou");
           admins.remove({mail:admin.mail})
              .then(command => {
                console.log("Admin deleted: ");
                res.status(201).send({create: true});
              })
              .catch((err) => {
                console.log("Error: " + err);
                res.send({error: 'Unable to delete: This admin doesn\'t exists'});//normaly a condition souhld check the err
              })
            }
*/






module.exports.getAdmins = (req,res) => {
  admins.find().toArray()
       .then(items => res.status(200).json(items))
}
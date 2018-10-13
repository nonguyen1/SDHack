const jwt = require('jsonwebtoken');
const secret ="toto";
const MongoClient = require('mongodb').MongoClient;
const ObjectID = require('mongodb').ObjectID;

module.exports.verifyToken = (req,res,next) => {
    console.log("token")
    var token = req.headers['x-access-token'];
    if (!token) return res.status(401).send({ auth: false, message: 'No token provided.' });
    console.log("token1")
    jwt.verify(token, secret, (err ,decoded) => {
      console.log("token2")
      if (err) return res.status(500).send({ auth: false, message: 'Failed to authenticate token.' });
      else{
        console.log("token3")
        req.userId = decoded.id;
        next();
      }
    })
  
  }

  module.exports.verifyTokenName = (req,res,next) => {
    console.log("token")
    var token = req.headers['x-access-token'];
    if (!token) return res.status(401).send({ auth: false, message: 'No token provided.' });
    console.log("token1")
    jwt.verify(token, secret, (err ,decoded) => {
      console.log("token2")
      if (err) return res.status(500).send({ auth: false, message: 'Failed to authenticate token.' });
      else{
        console.log("token3")
        req.userId = decoded.id;
        users.findOne(
          { _id: ObjectID(decoded.id) },
          { fields:{passwd: 0 }}
        )
            .then( item => {
                console.log(item)
                req.username = item.mail;
                next();
            })
           .catch(err => console.log("err" + err))
      }
    })
  
  }




module.exports.createAgreement = (req,res) => {

    const agreement = {
        sender: req.username,
        receiver: req.body.receiver,
        agreement: req.body.agreement
      }

    res.json(agreement)

}

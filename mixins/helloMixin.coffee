helloMixin = (route,model,router)->
	router.get route,(req,res,next)->
		model.find {},(err,result)->
			if(err)
				console.error err
			res.send result


module.exports = helloMixin
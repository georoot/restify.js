# This is code for token strategy in restify.js
bcrypt = require 'bcrypt'
jwt    = require 'jsonwebtoken'


routes = (route,model,router)->
	router.get route,(req,res,next)->
		res.send "this is the auth endpoint"

	# this is the login route
	router.post route,(req,res,next)->
		username = req.body['username']
		password = req.body['password']
		model.findOne {username:username},(err,model)->
			if(err)
				res
					.status 401
					.end()
			hash = model.password
			bcrypt.compare req.body['password'],hash,(err,match)->
				if (err)
					return res.status 401
						.end()
				if (match)
					# FIXME : take key from the private key file for better security
					token = jwt.sign({ userName: model.username
							,id:model._id
							,admin:model.is_superuser
							,salt: Math.random()
						}, 'shhhhh');
					existingTokens = JSON.parse model.token
					existingTokens.token.push token
					console.log existingTokens
					model.token = JSON.stringify existingTokens
					model.save()
					return res.status 200
						.json {key:token}
				else
					return res.status 401
						.end()

	router.post route+"/logout",(req,res,next)->
		token = req.body["token"]
		jwt.verify token, 'shhhhh',(err,decoded)->
			if(err)
				return res
					.status 401
					.end()
			userId = decoded.id
			model.findOne {_id:userId},(err,object)->
				if(err)
					return res
						.status 401
						.end()
				existingTokens = JSON.parse object.token
				index = existingTokens.token.indexOf token
				existingTokens.token.splice index,1
				object.token = JSON.stringify existingTokens
				object.save()
				return res.status 200
					.end()			

	# This is the signup route
	router.post route+"/signup",(req,res,next)->
		req.body['is_superuser'] = false
		req.body['token']        = '{"token":[]}'
		bcrypt.hash req.body['password'],5,(err,password)->
			if (err)
				return res.status 401
					.end()
			req.body.password = password
			new model req.body
				.save (err)->
					if(err)
						return res
							.status 401
							.json err
					res.send "route to create new user"

utils = ()->

	is_authenticated = (token)->
		console.log "Test if the user is authenticated"

	is_superuser = (token)->
		console.log "test if is_superuser"

module.exports["utils"] = utils
module.exports["routes"] = routes
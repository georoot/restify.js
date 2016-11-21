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
					# Generate some unique token over here
					token = jwt.sign({ user: model,salt: Math.random() }, 'shhhhh');
					return res.status 200
						.json {key:token}
				else
					return res.status 401
						.end()

	# This is the logout route
	router.delete router,(req,res,next)->
		res.send "You successfully logged out of the application"

	# This is the signup route
	router.post route+"/signup",(req,res,next)->
		req.body['is_superuser'] = false
		req.body['token']        = ""
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

	is_authenticated = ()->
		console.log "Test if the user is authenticated"

	is_superuser = ()->
		console.log "test if is_superuser"

module.exports["utils"] = utils
module.exports["routes"] = routes
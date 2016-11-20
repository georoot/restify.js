express  = require 'express'
mongoose = require 'mongoose'
jsonfile = require 'jsonfile'


context = (object)->
	this.object = object
	this.router = express.Router()
	this.models = []

	this.initDb = ()->
		mongoose.connect 'mongodb://localhost/'+this.object.__meta__.database
		console.log "Initializing database connection to : "+this.object.__meta__.database
		db = mongoose.connection
		db.on 'error', console.error.bind(console, 'connection error:')
		# Import all user defined models here
		for k, v of this.object.models
			this.models[k] = require v
			console.log "Importing model : "+k

	this.initRoutes = ()->
		for k, v of this.object.views
			for i in v.mixin
				require(i)(k,this.models[v.model],this.router)
			

	this.as_view = ()->
		this.router
		# this.router.get '/',(req,res,next)->
		# 	res.send "Testing context"

	return

restify = (file)->
	this.file = file

	this.onload = (clbFunction)->
		jsonfile.readFile this.file,(err,obj)->
			if (err)
				clbFunction false,{}
			this.context = new context obj
			this.context.initDb()
			this.context.initRoutes()
			clbFunction true,this.context

	this.echo = ()->
		console.log "Simple hello"
		return

	return

module.exports = restify;
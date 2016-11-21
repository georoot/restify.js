express  = require 'express'
mongoose = require 'mongoose'
jsonfile = require 'jsonfile'
chalk    = require 'chalk'
fs       = require 'fs'


context = (object)->
	this.object = object
	this.router = express.Router()
	this.models = []

	this.initDb = ()->
		mongoose.connect 'mongodb://localhost/'+this.object.__meta__.database
		console.log "Initializing database connection to : "+ chalk.blue this.object.__meta__.database
		db = mongoose.connection
		db.on 'error', console.error.bind(console, 'connection error:')
		# Import all user defined models here
		for k, v of this.object.models
			this.models[k] = require v
			console.log "Importing model : "+ chalk.blue k

	this.initRoutes = ()->
		for k, v of this.object.views
			for i in v.mixin
				require(i)("/"+this.object.__meta__.namespace+k,this.models[v.model],this.router)

	this.initAuthRoutes = ()->
		if this.object.__meta__.auth.enableAuth
			console.log chalk.red "enable auth endpoints"
			this.authModel = require this.object.__meta__.auth.userModel
			cert = fs.readFileSync this.object.__meta__.auth.privateKey
			require(this.object.__meta__.auth.authStrategy).routes("/"+this.object.__meta__.auth.routeHandle,this.authModel,this.router,cert)
			

	this.as_view = ()->
		this.router

	return

restify = ()->
	this.loadJson = (file)->
		this.file = file

	this.onload = (clbFunction)->
		jsonfile.readFile this.file,(err,obj)->
			if (err)
				clbFunction false,{}
			this.context = new context obj
			this.context.initDb()
			this.context.initRoutes()
			this.context.initAuthRoutes()
			clbFunction true,this.context

	return

module.exports = restify;
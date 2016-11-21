express = require 'express'
restify = require './app.js'
parser  = require 'body-parser'
chalk    = require 'chalk'

app = express()
app.use parser.urlencoded({ extended: false })

apiInstance = new restify
apiInstance.loadJson './config.json'

apiInstance.onload (status,context)->
	app.use '/',context.as_view()




app.listen 3000,()->
	console.log chalk.red 'App listening on port 3000!'
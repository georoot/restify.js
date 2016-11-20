express = require 'express'
restify = require('./app.js')

app = express()

apiInstance = new restify
apiInstance.loadJson './config.json'

apiInstance.onload (status,context)->
	app.use '/',context.as_view()




app.listen 3000,()->
	console.log('Example app listening on port 3000!')
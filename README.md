# restify.js

`Restify.js` is an express addon that can be used to design api much faster and elegantly. Currently the library provides minimalistic functions but they can be extended and customized.

### Installation

The library can be installed from `npm` itself.

### Design api configuration

A sample configuration for api is

```
{
	"__meta__":{
		"database": "restify",
		"namespace": "v1",
		"auth" : {
			"enableAuth": true,
			"routeHandle" : "auth",
			"userModel" : "restify.js/models/user.js",
			"authStrategy" : "restify.js/auth/tokenAuth.js",
			"privateKey": "Private key path comes here"
		}
	},
	"models":{
		"emailDetails": "./models/email.js"
	},
	"views" :{
		"/users": {
			"model" : "emailDetails",
			"mixin" : ["./mixins/helloMixin.js"]
		}
	}
}
```

Note this is a `json` file defined inside your project. `restify.js` depends on `mongodb` as its database. The name for database can be initialized in the `__meta__` section of the json. Models are the same as that from `mongoosejs` and a sample model is given below

```
var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var User = new Schema({
    name        : {type: String, required: false},
    email       : {type: String, required: true}
});

module.exports = mongoose.model('user', User);
```

which takes in `name` and `email` parameters.

### Adding api to express application

The code below is a simple example that takes in the configuration from above and adds it to the express app as routes. As you can see `restify.js` handles most of the parts within the framework and is hackable at the same time from json configuration above.

```
express = require 'express'
restify = require 'restify.js'
parser  = require 'body-parser'
chalk   = require 'chalk'

app = express()
app.use parser.urlencoded({ extended: false })

# Create new api instance
apiInstance = new restify
# Load json configuration
apiInstance.loadJson './config.json'

# Onload callback where you can add views
apiInstance.onload (status,context)->
	app.use '/',context.as_view()




app.listen 3000,()->
	console.log chalk.red 'App listening on port 3000!'
```

### Authentication endpoints

As it was scheduled, from **v0.0.2** `restify.js` provides internal mechanism for authentication and user management. This being said the system can be modified at will from the json configuration file. In the json configuration file consider this part of snippet

```
"auth" : {
	"enableAuth": true,
	"routeHandle" : "auth",
	"userModel" : "restify.js/models/user.js",
	"authStrategy" : "restify.js/auth/tokenAuth.js",
	"privateKey": "Private key path comes here"
}
```

This example takes token strategy for authentication provided inside `resify.js`. needless to say the `User model` and `strategy` can be changed at will.

* **enableAuth** is a boolean value that will actually determine whether authentication is required in the app
* **routeHandle** is url prefix for authentication. In this case authentication is accessible at '/auth'
* **userModel** this is the user model provided by default inside `restify.js`. You can always use custom model here
* **authStrategy** Strategy is a set of views and utils that are used for authentication. `restify.js` by default comes with stratgy for token authentication using `JSON web tokens`. You can change this to use a custom strategy
* **privateKey** Security of a system is very important therefore rather than using secret key for generating tokens, `restify.js` directly take `rsa` private key to generate the tokens.


#### How to use token authentication strategy

The following endpoints provide more extensive use for the token strategy. The url is being generated from the json configuration mentioned above.

* *POST* `/auth` This is the login route and requires `username` and `password` to authenticate.
* *POST* `/auth/logout` The logout route and needs `token` as post parameter.
* *POST* `/auth/signup` Create new user by user model as defined in json configuration

Strategy also comes with `utils` functions that are helpers and can be used in other routes in `express`

* `is_authenticated` This takes in `token` and returns `boolean`
* `is_superuser`     This takes in `token` and returns `boolean`

Token strategy is still under development and pull requests are appreciated


### What is `mixin`

A lot of api calls are always `CRUD` in nature and mixins solve this problem. You can create your own mixins and also **if you are creating a generic mixin and want to share that send a pull request on github**. A sample mixin code is as given below

```
module.exports = (route,model,router)->
	router.get route,(req,res,next)->
		model.find {},(err,result)->
			if(err)
				console.error err
			res.send result
```

`restify.js` will automatically pass the model as defined in configuration. In this example of mixin it is returning all the data in a simple get request.


### Roadmap

Here are the list of features implemented and in the process of being implemented. If you have some suggestions you can always make a pull request in github repo.


- [x] Implement mixin framework
- [x] Implement model framework
- [x] Implement authentication as a part of framework
- [ ] Add default mixins inside the library
- [ ] HTML based api browser like `postman`
- [ ] Add YAML support compatible with swagger.io
- [ ] Request throttling
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
	},
	"models":{
		"userDetails": "./models/user.js",
		"emailDetails": "./models/email.js"
	},
	"views" :{
		"/users": {
			"model" : "userDetails",
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


### Rodamap

Here are the list of features implemented and in the process of being implemented. If you have some suggestions you can always make a pull request in github repo.


- [x] Implement mixin framework
- [x] Implement model framework
- [ ] Implement authentication as a part of framework
- [ ] Add default mixins inside the library
- [ ] HTML based api browser like `postman`
- [ ] Add YAML support compatible with swagger.io
- [ ] Request throttling
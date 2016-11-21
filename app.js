// Generated by CoffeeScript 1.11.1
var chalk, context, express, jsonfile, mongoose, restify;

express = require('express');

mongoose = require('mongoose');

jsonfile = require('jsonfile');

chalk = require('chalk');

context = function(object) {
  this.object = object;
  this.router = express.Router();
  this.models = [];
  this.initDb = function() {
    var db, k, ref, results, v;
    mongoose.connect('mongodb://localhost/' + this.object.__meta__.database);
    console.log("Initializing database connection to : " + chalk.blue(this.object.__meta__.database));
    db = mongoose.connection;
    db.on('error', console.error.bind(console, 'connection error:'));
    ref = this.object.models;
    results = [];
    for (k in ref) {
      v = ref[k];
      this.models[k] = require(v);
      results.push(console.log("Importing model : " + chalk.blue(k)));
    }
    return results;
  };
  this.initRoutes = function() {
    var i, k, ref, results, v;
    ref = this.object.views;
    results = [];
    for (k in ref) {
      v = ref[k];
      results.push((function() {
        var j, len, ref1, results1;
        ref1 = v.mixin;
        results1 = [];
        for (j = 0, len = ref1.length; j < len; j++) {
          i = ref1[j];
          results1.push(require(i)("/" + this.object.__meta__.namespace + k, this.models[v.model], this.router));
        }
        return results1;
      }).call(this));
    }
    return results;
  };
  this.initAuthRoutes = function() {
    if (this.object.__meta__.auth.enableAuth) {
      console.log(chalk.red("enable auth endpoints"));
      this.authModel = require(this.object.__meta__.auth.userModel);
      return require(this.object.__meta__.auth.authStrategy).routes("/" + this.object.__meta__.auth.routeHandle, this.authModel, this.router);
    }
  };
  this.as_view = function() {
    return this.router;
  };
};

restify = function() {
  this.loadJson = function(file) {
    return this.file = file;
  };
  this.onload = function(clbFunction) {
    return jsonfile.readFile(this.file, function(err, obj) {
      if (err) {
        clbFunction(false, {});
      }
      this.context = new context(obj);
      this.context.initDb();
      this.context.initRoutes();
      this.context.initAuthRoutes();
      return clbFunction(true, this.context);
    });
  };
};

module.exports = restify;

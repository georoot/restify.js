// Generated by CoffeeScript 1.11.1
var context, express, jsonfile, mongoose, restify;

express = require('express');

mongoose = require('mongoose');

jsonfile = require('jsonfile');

context = function(object) {
  this.object = object;
  this.router = express.Router();
  this.models = [];
  this.initDb = function() {
    var db, k, ref, results, v;
    mongoose.connect('mongodb://localhost/' + this.object.__meta__.database);
    console.log("Initializing database connection to : " + this.object.__meta__.database);
    db = mongoose.connection;
    db.on('error', console.error.bind(console, 'connection error:'));
    ref = this.object.models;
    results = [];
    for (k in ref) {
      v = ref[k];
      this.models[k] = require(v);
      results.push(console.log("Importing model : " + k));
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
          results1.push(require(i)(k, this.models[v.model], this.router));
        }
        return results1;
      }).call(this));
    }
    return results;
  };
  this.as_view = function() {
    return this.router;
  };
};

restify = function(file) {
  this.file = file;
  this.onload = function(clbFunction) {
    return jsonfile.readFile(this.file, function(err, obj) {
      if (err) {
        clbFunction(false, {});
      }
      this.context = new context(obj);
      this.context.initDb();
      this.context.initRoutes();
      return clbFunction(true, this.context);
    });
  };
  this.echo = function() {
    console.log("Simple hello");
  };
};

module.exports = restify;
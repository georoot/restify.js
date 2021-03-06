// Generated by CoffeeScript 1.11.1
var helloMixin;

helloMixin = function(route, model, router) {
  return router.get(route, function(req, res, next) {
    return model.find({}, function(err, result) {
      if (err) {
        console.error(err);
      }
      return res.send(result);
    });
  });
};

module.exports = helloMixin;

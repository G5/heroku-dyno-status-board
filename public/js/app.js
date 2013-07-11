var App = Ember.Application.create();

// Router
App.Router.map(function() {
  this.resource('heroku_apps', function(){
    this.resource('heroku_app', { path: ':heroku_app_id' });
  });
});

App.HerokuAppsRoute = Ember.Route.extend({
  model: function() {
    return App.HerokuApp.find();
  }
});

// Controllers


// Models
App.Store = DS.Store.extend();

App.HerokuApp = DS.Model.extend({
  name: DS.attr('string'),
  dynos: DS.attr('number'),
  workers: DS.attr('number')
});

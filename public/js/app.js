var G5 = Ember.Application.create();

// Router
G5.Router.map(function() {
  this.resource('apps', function(){
    this.resource('app', { path: ':app_id' });
  });
});

G5.AppsRoute = Ember.Route.extend({
  model: function() {
    return G5.App.find();
  }
});

// Controllers
G5.AppsController = Ember.ArrayController.extend({
  sortProperties: ['dynos'],
  sortAscending: false
});

G5.AppController = Ember.ObjectController.extend({
  addDyno: function(app) {
    app.set('dynos', app.get('dynos')+1);
    app.save()
  },
  removeDyno: function(app) {
    app.set('dynos', app.get('dynos')-1);
    app.save()
  },
  removeAllDynos: function(app) {
    app.set('dynos', 0);
    app.save()
  }
});

// Models
DS.RESTAdapter.reopen({
  namespace: 'heroku'
});

G5.Store = DS.Store.extend();

G5.App = DS.Model.extend({
  name: DS.attr('string'),
  dynos: DS.attr('number')
});

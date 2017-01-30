import Ember from 'ember';

export default Ember.Route.extend({
  model: function(){
    return this.store.findAll('token');
  },
  setupController: function(controller, model){
    controller.set('token', model.get('firstObject'));
  },

  actions:{
    toDb: function(){
      window.location.replace(window.location.href + "rails/db");

    },
  }

});

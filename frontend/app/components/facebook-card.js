import Ember from 'ember';
import moment from 'moment';

export default Ember.Component.extend({
  moment: Ember.inject.service(),
  token: null,
  store: Ember.inject.service(),
  authenticating: false,
  status: null,

  actions:{
    reAuthenticate: function(){
      this.set('authenticating', true);
      var store = this.get('store');
      var token = store.createRecord('token',{});
      token.save().then(function(token){
         window.open(token.get('url'));
         this.set('authenticating', false);
         this.set('status', "Please follow link to authenticate then refresh");
      }.bind(this), function(error){
        this.set('authenticating', false);
        this.set('status', "Something went wrong, please try again");
      }.bind(this));

    },
  }

});

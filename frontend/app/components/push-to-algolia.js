import Ember from 'ember';

export default Ember.Component.extend({
  store: Ember.inject.service(),
  pushing: false,
  loadingResults: false,

  fetching: function(){
    Ember.run.later(function(){
      if(!this.isDestroyed){
        this.set('loadResults', false);
      }
    }.bind(this), 500);
  },

  actions: {
    pushData: function(){
      this.set('loadingResults', true);
      var store = this.get('store');
      store.createRecord('algolia', {}).save().then(function(){
        this.fetching();
      }.bind(this), function(){
        this.fetching();
      }.bind(this))
    },
  }
});

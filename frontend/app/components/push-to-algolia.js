import Ember from 'ember';

export default Ember.Component.extend({
  store: Ember.inject.service(),
  pushing: false,
  loadingResults: false,
  pushingTalks: false,
  loadingTalks: false,

  fetching: function(){
    Ember.run.later(function(){
      if(!this.isDestroyed){
        this.set('loadResults', false);
      }
    }.bind(this), 500);
  },
  fetchingTalks: function(){
    Ember.run.later(function(){
      if(!this.isDestroyed){
        this.set('loadingTalks', false);
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
    newTalks: function(){
      this.set('loadingTalks', true);
      var store = this.get('store');
      store.createRecord('talk', {}).save().then(function(){
        this.fetchingTalks();
      }.bind(this), function(){
        this.fetchingTalks();
      }.bind(this))
    },
  }
});

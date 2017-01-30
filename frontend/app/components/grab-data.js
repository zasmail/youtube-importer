import Ember from 'ember';

export default Ember.Component.extend({
  store: Ember.inject.service(),
  talks: null,
  playlists: null,
  talksUpdated: null,
  playlistsUpdated: null,
  loadingResults: true,
  status: null,
  running: false,

  initialLoad: Ember.on('init', function(){
    this.loadResults();
  }),

  loadResults: function(){
    var store = this.get('store');
    this.set('loadingResults', true);
    store.createRecord('status', {}).save().then(function(results){
      this.set('talks', results.get('talks'));
      this.set('playlists', results.get('playlists'));
      this.set('loadingResults', false);
    }.bind(this), function(error){
      this.set('loadingResults', false);
    }.bind(this));

  },

  actions: {
    reloadResults: function(){
      this.set('loadingResults', true);
      Ember.run.later(function(){
        if(!this.isDestroyed){
          this.loadResults();
        }
      }.bind(this), 500);
    },

    getData: function(){
      var store = this.get('store');
      this.set('running', true);
      this.set('started', true);
      store.createRecord('youtube', {}).save().then(function(results){
        this.set('running', false);
      }.bind(this), function( error ){
        this.set('running', false);
      }.bind(this));
    },
    getSocial: function(){
      var store = this.get('store');
      this.set('runningSocial', true);
      store.createRecord('social', {}).save().then(function(results){
        this.set('runningSocial', false);
      }.bind(this), function( error ){
        this.set('runningSocial', false);
      }.bind(this));
    },
  }

});

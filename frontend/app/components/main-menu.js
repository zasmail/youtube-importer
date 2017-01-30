import Ember from 'ember';

export default Ember.Component.extend({
  items: [
    {icon: "lock open", title: "Authenticate Facebook", route: "facebook"},
    {icon: "cloud download", title: "Grab data", route: "data"},
    {icon: "whatshot", title: "Grab social data", route: "social"},
    {icon: "cloud upload", title: "Push to Algolia", route: "algolia"},
  ],

  actions:{
    facebook: function(){
      this.sendAction('reRoute', 'facebook');
    },
    data: function(){
      this.sendAction('reRoute', 'data');
    },
    social: function(){
      this.sendAction('reRoute', 'social');
    },
    algolia: function(){
      this.sendAction('reRoute', 'algolia');
    },
  }
});

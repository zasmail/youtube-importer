import Ember from 'ember';

export default Ember.Component.extend({
  token: null,


  actions:{
    toggleSidebar: function(){
      this.toggleProperty('leftSideBarOpen');
    },
    newMenu: function(menu){
    }
  }

});

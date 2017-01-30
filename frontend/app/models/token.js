import DS from 'ember-data';

export default DS.Model.extend({
  expires: DS.attr('date'),
  url: DS.attr(),

  isValid: Ember.computed('expires', function(){
    return this.get('expires') > Date.now();
  }),
  tokenClass: Ember.computed('expires', function(){
    var daysRemaing = Math.floor(( this.get('expires') - Date.now() ) / 86400000);
    if(daysRemaing > 3){
      return "token-good";
    }
    else if(daysRemaing > 0){
      return "token-warning";
    }else{
      return "token-invalid";
    }
  }),

});

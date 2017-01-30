import DS from 'ember-data';

export default DS.Model.extend({
  playlists: DS.attr(),
  talks: DS.attr(),
  socialt: DS.attr(),
  socialp: DS.attr(),
  started: DS.attr('date'),

});

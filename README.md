# Importer

This is a Rails backend with an Ember.JS frontend designed to grab data from Youtube, format it, find additional information about each video from various social media sources and then export it to Algolia.

##Use it:
* [Front end](https://sheltered-citadel-56202.herokuapp.com/)
* [Check out the Database](https://sheltered-citadel-56202.herokuapp.com/rails/db)

##Services:
### [authenticate_facebook_service.rb](https://github.com/zasmail/youtube-importer/blob/master/app/services/authenticate_facebook_service.rb)

### [create_talk_from_youtube.rb](https://github.com/zasmail/youtube-importer/blob/master/app/services/create_talk_from_youtube.rb)

### [import_channels.rb](https://github.com/zasmail/youtube-importer/blob/master/app/services/import_channels.rb)

### [import_playlists_from_channel.rb](https://github.com/zasmail/youtube-importer/blob/master/app/services/import_playlists_from_channel.rb)

###[ import_videos_from_channel.rb](https://github.com/zasmail/youtube-importer/blob/master/app/services/import_videos_from_channel.rb)

### [update_images.rb](https://github.com/zasmail/youtube-importer/blob/master/app/services/update_images.rb)

### [update_social.rb](https://github.com/zasmail/youtube-importer/blob/master/app/services/update_social.rb)

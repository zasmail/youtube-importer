# Importer

This is a Rails backend with an Ember.JS frontend designed to grab data from Youtube, format it, find additional information about each video from various social media sources and then export it to Algolia.

##Use it:
* [Front end](https://sheltered-citadel-56202.herokuapp.com/)
* [Check out the Database](https://sheltered-citadel-56202.herokuapp.com/rails/db)

##Services:
### [authenticate_facebook_service.rb](https://github.com/zasmail/youtube-importer/blob/master/app/services/authenticate_facebook_service.rb)

Fectches a new Facebook OAuth Token. These tokens last 3 months.
### [create_talk_from_youtube.rb](https://github.com/zasmail/youtube-importer/blob/master/app/services/create_talk_from_youtube.rb)
This will parse data retrieved from the YouTube API and save a "Talk" object to the DB
Things to note:
* Built in functionality to detect language
* Ted specific because it will parse a videos title to try and retrieve the speaker's name
* Youtube API returns several size thumbnails, for the purposes of the TED demo, we needed the largest ones. If that is not available, will default to second largest.

### [import_channels.rb](https://github.com/zasmail/youtube-importer/blob/master/app/services/import_channels.rb)
* Not accessible through frontend
* Will save all of the channels and all the channels that a particular channel is subscribed to

### [import_playlists_from_channel.rb](https://github.com/zasmail/youtube-importer/blob/master/app/services/import_playlists_from_channel.rb)
* Will access the Youtube API to retrieve all the playlists from a given channel
* Will call the `create_talk_from_youtube` service on all of the playlists' videos
* Will determine language based on the name of the playlist and it's description

###[ import_videos_from_channel.rb](https://github.com/zasmail/youtube-importer/blob/master/app/services/import_videos_from_channel.rb)
* Will access the Youtube API to retrieve all the videos from a given channel
* Will call the `create_talk_from_youtube` service on all of the videos

### [push_to_algolia.rb](https://github.com/zasmail/youtube-importer/blob/master/app/services/push_to_algolia.rb)
* Formats all playlists and videos for Algolia and pushes them

### [update_images.rb](https://github.com/zasmail/youtube-importer/blob/master/app/services/update_images.rb)
* Makes an external request to see if a given photo exists

### [update_social.rb](https://github.com/zasmail/youtube-importer/blob/master/app/services/update_social.rb)
* Gathers data on talks and playlists from these external services:
  * facebook
  * google
  * reddit
  * linkedin
  * pinterest

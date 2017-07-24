#!/usr/bin/env bash

#my api key - don't touch
my_api='AIzaSyAOLj5NfPkmhf30gOtsGBYrgCbpRM36-44' #works
# end don't touch

#search killians page for channels - don't touch
#usernames who commented on one of killians vids:
getUsernames_channel='UCjdQaSJCYS4o2eG93MvIwqg' #works #killian
getUsernames_part="snippet,id"
curl "https://www.googleapis.com/youtube/v3/search?key=$my_api&channelId=$getUsernames_channel&part=$getUsernames_part&order=date&maxResults=20"
#end don't touch





#search playlist don't touch
#playlist of one of those people
playlist_list_id='LL4kfP9ugDYv_jkiW9poPgOw'
playlist_part="snippet,contentDetails"
#curl "https://www.googleapis.com/youtube/v3/playlists?part=$playlist_part&key=$my_api&id=$playlist_list_id&order=date&maxResults=20"
# end don't touch



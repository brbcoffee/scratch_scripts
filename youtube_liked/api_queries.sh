#!/usr/bin/env bash

####my api key - don't touch
my_api='AIzaSyAOLj5NfPkmhf30gOtsGBYrgCbpRM36-44' #works
#### end don't touch

####search killians page for videos - don't touch
#usernames who commented on one of killians vids:
getUsernames_channel='UCjdQaSJCYS4o2eG93MvIwqg' #works #killian
getUsernames_part="snippet,id"
###curl "https://www.googleapis.com/youtube/v3/search?key=$my_api&channelId=$getUsernames_channel&part=$getUsernames_part&order=date&maxResults=20"
####end don't touch

####get commentThread on a video - don't touch
getComments_part="snippet,replies"
getComments_videoId='UOv_AcIyRYE'
###curl "https://www.googleapis.com/youtube/v3/commentThreads?key=$my_api&part=$getComments_part&videoId=$getComments_videoId&order=relevance&maxResults=20"
####end don't touch

####get comments on a video 
getComments_part="snippet,replies"
getComments_videoId='UOv_AcIyRYE'
curl "https://www.googleapis.com/youtube/v3/commentThreads?key=$my_api&part=$getComments_part&videoId=$getComments_videoId&order=relevance&maxResults=100"



#from user id -> playlist

getPlaylist_part="snippet,id"
getPlaylist_channelId="UC6Hh68BGyt99WsD-85u8t7A"



####search playlist don't touch
#playlist of one of those people
playlist_list_id='LL4kfP9ugDYv_jkiW9poPgOw'
playlist_part="snippet,contentDetails"
###curl "https://www.googleapis.com/youtube/v3/playlists?part=$playlist_part&key=$my_api&id=$playlist_list_id&order=date&maxResults=20"
#### end don't touch



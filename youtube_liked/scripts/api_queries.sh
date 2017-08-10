#!/usr/bin/env bash

####my api key - don't touch
my_api='AIzaSyCKUYeVIeTz2Y9hnGBKeJtq475EQsDNY-w' #works
#### end don't touch

#key to using api:
#use part snippet to get top level with identifying info
#then use an identifier to locate a specific item

#### get videos from a channel
getUsernames_part="snippet,id"
getUsernames_channel='UCjdQaSJCYS4o2eG93MvIwqg' #works #killian
#curl "https://www.googleapis.com/youtube/v3/search?key=$my_api&channelId=$getUsernames_channel&part=$getUsernames_part&order=date&maxResults=20"


####get commentThread on a video - don't touch
getComments_part="snippet,replies"
getComments_videoId='UOv_AcIyRYE'
###curl "https://www.googleapis.com/youtube/v3/commentThreads?key=$my_api&part=$getComments_part&videoId=$getComments_videoId&order=relevance&maxResults=20"
####end don't touch

####get comments on a video and iterate - don't touch
getComments_part="snippet,replies"
getComments_videoId='ggiMGaq7Ue4'
r=`curl "https://www.googleapis.com/youtube/v3/commentThreads?key=$my_api&part=$getComments_part&videoId=$getComments_videoId&order=relevance&maxResults=1"`
echo $r
next_token=`echo $r | jq -r '.nextPageToken'`
echo $next_token
next_token=""
next=`curl "https://www.googleapis.com/youtube/v3/commentThreads?key=$my_api&part=$getComments_part&videoId=$getComments_videoId&order=relevance&maxResults=1&pageToken=$next_token"`
echo $next
#next=`curl "https://www.googleapis.com/youtube/v3/commentThreads?key=$my_api&part=$getComments_part&videoId=$getComments_videoId&order=relevance&maxResults=1&pageToken=$next_token"`
#### don't touch

#from user id -> playlist
getPlaylist_part="snippet"
getPlaylist_channelId="UC1M9ArsuMpBNadpjLXZ4o6g"
#curl "https://www.googleapis.com/youtube/v3/playlists?part=$getPlaylist_part&key=$my_api&channelId=$getPlaylist_channelId&order=date&maxResults=20"
## end don't touch


getPlaylist_part="snippet"
getPlaylist_channelId="UC1M9ArsuMpBNadpjLXZ4o6g"
#curl "https://www.googleapis.com/youtube/v3/search?key=$my_api&channelId=$getPlaylist_channelId&part=$getPlaylist_part&order=date&maxResults=20"

#playlist of one of those people don't touch
playlist_list_id='LL4kfP9ugDYv_jkiW9poPgOw'
playlist_part="snippet,contentDetails"
#curl "https://www.googleapis.com/youtube/v3/playlists?part=$playlist_part&key=$my_api&id=$playlist_list_id&order=date&maxResults=20"
#### end don't touch

### 
playlist_part="snippet"
playlist_list_id='LL4kfP9ugDYv_jkiW9poPgOw'
#curl "https://www.googleapis.com/youtube/v3/playlistItems?part=$playlist_part&key=$my_api&playlistId=$playlist_list_id&order=date&maxResults=1"


# get channel id from video id
video_part="snippet"
video_list_id='9Ev2c4ZELmI'
#video_list_id='UOv_AcIyRYE'
#curl "https://www.googleapis.com/youtube/v3/videos?key=$my_api&part=$video_part&id=$video_list_id"
#to get channel id:
#./api_queries.sh  | jq .items[].snippet.channelId







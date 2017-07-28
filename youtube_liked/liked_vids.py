#!/usr/bin/env python

import requests
import argparse
import os
import json
from bs4 import BeautifulSoup

with open('/Users/ericyoung/api/api_key', 'r') as infile:
    my_api_key = infile.read()
max_results = 5 # 50 costs 600 quota points
max_comments = 1
static = "on"
static = "off"
debug = 0

def retrieve_video_list_from_channel(channel_id):
    # input: original channel id to get recs for
    # output: list of videos from the channel
    # static output: dump of video channels
    # static input: output of last non-static query
    component = "search"
    payload = {
        "key": my_api_key,
        "part":"snippet,id",
        "channelId": channel_id,
        "order": "date",
        "maxResults": max_results
    }
    if static == "on":
        results = query_static( "video_id_retrieval")
    else:
        results = query_youtube(component, payload, "video_id_retrieval")

    channel_video_list = []
    for i in results["items"]:
        for j in i["id"]["videoId"]:
            print j
            #channel_video_list.append(i["id"]["videoId"][j]["snippet"])
    #print channel_video_list
    return channel_video_list

def retrieve_top_comment_channel_id_from_videos(video_list):
    # input: list of videos from original channel
    # output: comment dump of commentThreads
    # static output: dump of commentThreads
    # static input: output of last non-static query
    component = "commentThreads"
    payload = {
        "key": my_api_key,
        "part":"snippet,replies",
        "channelId": channel_id,
        "order": "relevance",
        "maxResults": max_comments
    }
    # will want to iterate this later
    if static == "on":
        results = query_static("username_retrieval_dump")
    else:
        results = query_youtube(component, payload, "username_retrieval_dump")

    channel_id_list = []
    for i in results["items"]:
        print i["snippet"]["topLevelComment"]
        #channel_id_list.append(i["snippet"]["topLevelComment"]["snippet"]["authorChannelId"]["value"])
    #print channel_id_list
    return channel_id_list

def retrieve_liked_videos_playlist_from_users(commenter_channel_id_list):
    # input: channel ids of commentors on videos from original channel
    # output: liked videos from commentors channels
    # static output: liked videos from commentors channels
    # static input: output of last non-static query
    list_of_liked_video_lists = []
    if static == "off" and os.path.isfile("liked_videos_from_commentors"):
        os.remove("liked_videos_from_commentors")
    if static == "on":
        #read from static file
        list_of_liked_video_lists = query_static_list("liked_videos_from_commentors")
        print type(list_of_liked_video_lists)
        return list_of_liked_video_lists

    for commenter_channel_id in commenter_channel_id_list:
        url = "https://www.youtube.com/channel/" + commenter_channel_id
        #read from youtube and write output to static file
        list_of_liked_video_lists.append(scrape_youtube(url, "liked_videos_from_commentors"))
        if len(list_of_liked_video_lists[-1]) == 0:
            del list_of_liked_video_lists[-1]
        else:
            print "User: %s likes the videos: %s" % (commenter_channel_id, list_of_liked_video_lists[-1])
        #



    if debug == 1:
        print "list of liked video lists: %s" % (list_of_liked_video_lists)
    liked_video_list = []
    for l in list_of_liked_video_lists:
        for item in l:
            liked_video_list.append(item)
    return liked_video_list

def retrieve_recommended_channels(liked_video_list):
    # input: list of videos that have been liked by commentors
    # output: channel ids of these videos
    # static output: dump of commentThreads
    # static input: output of last non-static query
    print "\nretrieving recommended channels"
    recommended_channel_list = []
    for video_id in liked_video_list:
        component = "videos"
        payload = {
            "key": my_api_key,
            "part":"snippet",
            "id": video_id,
            "maxResults": max_results
        }
        # will want to iterate this later
        if static == "on":
            results = query_static("recommended_channel_list")
        else:
            results = query_youtube(component, payload, "recommended_channel_list")

        #print json.dumps(results, indent=4)
        for i in results["items"]:
            #print json.dumps(i["snippet"]["channelId"], indent=4)
            recommended_channel_list.append(i["snippet"]["channelId"])
    return recommended_channel_list


def scrape_youtube(url, debug_fh):
    r = requests.get(url)
    data = r.text
    soup = BeautifulSoup(data, "lxml")
    liked_video_full_url = []
    if str(soup).count('Liked') < 3:
        return liked_video_full_url
    for script in soup.find_all('script'):
        if type(script.string) is not 'NoneType':
            #print script.string
            if "itemListElement" in str(script.string):
                navigable_strings = json.loads(str(script.string))
                #for i in navigable_strings["itemListElement"]:
                if len(navigable_strings["itemListElement"]) > 0:
                    for i in navigable_strings["itemListElement"][0]["item"]["itemListElement"]:
                        liked_video_full_url.append(i["url"])
    liked_video_list = []
    for i in liked_video_full_url:
        liked_video_list.append(i.split('=')[1])
    with open(debug_fh, 'a') as outfile:
        for item in liked_video_list:
            if len(item) > 0:
                print>>outfile, item
    #print "Liked video list: %s" % (liked_video_list)
    return liked_video_list


def query_youtube(component, payload, debug_fh):
    host = "https://www.googleapis.com/youtube/v3/%s" % (component)
    r = requests.get(url=host, params=payload)
    if debug == 1:
        print "Requests: "
        print host
        print payload
    results = json.loads(r.text)
    with open(debug_fh, 'w') as outfile:
        json.dump(results, outfile)
    return results

def query_static(debug_fh):
    json_data = open(debug_fh).read()
    results = json.loads(json_data)
    return results

def query_static_list(debug_fh):
    list_data = []
    fh = open(debug_fh).readlines()
    for line in fh:
        list_data.append(line)
    return list_data

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('-c', '--channel', dest='channel_id', required=True, help="Enter user to develop recommendations for.")
    args = parser.parse_args()
    channel_id = args.channel_id
    print "querying youtube for retrieve_video_list_from_channel"
    channel_video_list = retrieve_video_list_from_channel(channel_id)
    print "querying youtube for retrieve_top_comment_channel_id"
    commenter_channel_id_list = retrieve_top_comment_channel_id_from_videos(channel_video_list)
    print "scraping youtube for retrieve_liked_videos"
    liked_video_list = retrieve_liked_videos_playlist_from_users(commenter_channel_id_list)
    print "querying youtube for retrieve_recommended_channels"
    recommended_channel_list = retrieve_recommended_channels(liked_video_list)
    for recommended_channel in recommended_channel_list:
        print "Channel %s recommended %s times" % (recommended_channel, recommended_channel_list.count(recommended_channel))

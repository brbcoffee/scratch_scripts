#!/usr/bin/env python


from bs4 import BeautifulSoup
import requests
import json
import pprint

url = "https://www.youtube.com/watch?v=ggiMGaq7Ue4" #killian vid
#url = "https://www.youtube.com/channel/UCW_WrRZV-gZgh7eeceqOoJw" #has liked
#url = "https://www.youtube.com/channel/UCaQLl2nJFD45SKVmrcy1j8g" # does not have liked
r = requests.get(url)
data = r.text
url_list = []

soup = BeautifulSoup(data, "lxml")
print(soup.prettify())
#print str(soup).count('Liked')
exit(0)

for script in soup.find_all('script'):
	if type(script.string) is not 'NoneType':
		if "itemListElement" in str(script.string):
			navigable_strings = json.loads(str(script.string))
			print json.dumps(navigable_strings, indent=4, sort_keys=True)
			#temp_list = navigable_strings["itemListElement"]
			for i in navigable_strings["itemListElement"]:
				for j in i["item"]["itemListElement"]:
					url_list.append(j["url"])


#for link in soup.find_all('a'):
#    print(link.get('href'))

#for span in soup.find_all('span'):
#    if span.string == "Liked videos":
#    	print(span)

#for title in soup.find_all('title'):
#    print(title.string)
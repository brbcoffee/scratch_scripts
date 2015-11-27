A simple script for determining if a solr source has written new documents on the current date. It's my first ever python script so, uh, you are so warned.

To be tied into nagios or other monitoring system. Checks if source is broken or, if you query the solr slaves, if a slave is not replicating (hey, it happens!)

The public version is made quite vague with url query (as I have no understanding of your solr syntax). My internal version has an envrionmental and leg query given to user, and the url is constructed from that.

Usage:

./solrNewAssetsPublic.py [-s] -i source.txt 

Use with caution, of course. However, we are only querying solr...hard to see the harm in it.

-ey

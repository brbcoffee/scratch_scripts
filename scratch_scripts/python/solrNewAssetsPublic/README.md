A simple script for determining if a solr source has written new documents today. To be tied into nagios or other monitoring system. Checks if source is broken or if slave is not replicating (hey, it happens!)

The public verision is made quite vauge with url query (as I have no understanding of your solr syntax). My internal version has an envrionmental and leg query, and the url is constructed from that.

Use with caution, of course. However, we are only querying solr...hard to see the harm in it.

-ey

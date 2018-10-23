#!/usr/bin/python2

import urllib2
import yaml

__author__ = "mutantmonkey <mutantmonkey@mutantmonkey.in>"
__license__ = 'WTFPL'


def update_feeds(feeds, feed_output):
    # calendar
    r = urllib2.urlopen(feeds['calendar'])
    with open(feed_output['calendar'], 'w') as f:
        f.write(r.read())

    # identi.ca
    #r = urllib2.urlopen(feeds['identica'])
    #with open(feed_output['identica'], 'w') as f:
    #    f.write(r.read())

    # vtluug-announce list
    r = urllib2.urlopen(feeds['list-vtluug-announce'])
    with open(feed_output['list-vtluug-announce'], 'w') as f:
        f.write(r.read())

    # vtluug list
    r = urllib2.urlopen(feeds['list-vtluug'])
    with open(feed_output['list-vtluug'], 'w') as f:
        f.write(r.read())


if __name__ == "__main__":
    config_path = '../vtluug.conf'
    conf = yaml.load(open(config_path))
    update_feeds(conf['feeds'], conf['feed_output'])

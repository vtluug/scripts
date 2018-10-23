###############################################################################
# meeting.py - VTLUUG wiki meeting page creation script
#
# author: mutantmonkey <mutantmonkey@mutantmonkey.in>
###############################################################################

import datetime
import dateutil.parser
import jinja2
import pytz
import urllib2
import vobject
import wikitools
import yaml

__author__ = "mutantmonkey <mutantmonkey@mutantmonkey.in>"
__license__ = 'WTFPL'


def datetimeformat(value, format='%Y-%m-%d %H:%M'):
    return value.strftime(format)


def scrape_meetings(wiki, calendar, calurl, templates_dir):
    env = jinja2.Environment(loader=jinja2.FileSystemLoader(templates_dir))
    env.filters['dateformat'] = datetimeformat

    nextmeeting = None
    meetings = []

    cal = vobject.readComponents(calendar)

    for ev in cal:
        if ev.vevent.summary.value != "VTLUUG Meeting":
            continue

        if ev.vevent.rruleset:
            for dt in ev.vevent.rruleset:
                # handle only upcoming events
                try:
                    if dt < datetime.datetime.now(pytz.utc):
                        continue
                except TypeError:
                    # we don't use full day events, so just skip them
                    continue

                try:
                    evlen = ev.vevent.dtend.value - ev.vevent.dtstart.value
                except AttributeError:
                    pass

                loc = ev.vevent.location.value.split(' ')
                evstart = dateutil.parser.parse(str(dt))
                evstart = evstart.astimezone(dateutil.tz.tzlocal())
                evend = dateutil.parser.parse(str(dt + evlen))
                evend = evend.astimezone(dateutil.tz.tzlocal())

                template = env.get_template('meeting')
                output = template.render({
                    'room': loc[0],
                    'building': " ".join(loc[1:]),
                    'date': evstart,
                    'dateend': evend,
                })

                title = evstart.strftime('VTLUUG:%Y-%m-%d')

                if not nextmeeting:
                    nextmeeting = (title, evstart)

                # create page for meeting
                page = wikitools.page.Page(wiki, title)
                if page.exists:
                    print("{0}: page already exists".format(title))
                else:
                    page.edit(text=output, bot=True)

    # set next meeting redirect
    if nextmeeting:
        page = wikitools.page.Page(wiki, "VTLUUG:Next meeting",
                followRedir=False)
        page.edit(text="#REDIRECT [[{0}]]".format(nextmeeting[0]), bot=True,
                summary="Update next meeting redirect")

        page = wikitools.page.Page(wiki, "VTLUUG:Calendar")
        template = env.get_template('calendar')
        output = template.render({
            'date': nextmeeting[1],
            'fullurl': calurl,
        })
        page.edit(text=output, bot=True, summary="Update next meeting date")

if __name__ == '__main__':
    config_path = '../vtluug.conf'
    conf = yaml.load(open(config_path))

    wiki = wikitools.wiki.Wiki(conf['wiki']['api'])
    wiki.login(conf['wiki']['username'], conf['wiki']['password'],
            domain=conf['wiki']['domain'])

    ics = conf['feeds']['calendar']
    calendar = urllib2.urlopen(ics).read()
    scrape_meetings(wiki, calendar, conf['urls']['calendar'], 'templates')

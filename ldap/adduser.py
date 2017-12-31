#!/usr/bin/python2
###############################################################################
# adduser.py - create LDAP user
#
# author: mutantmonkey <mutantmonkey@mutantmonkey.in>
###############################################################################

import ldap
import ldap.modlist
import lib
import re

# FIXME: blank = auto increment
uid = raw_input("UID (make sure it is unused!): ")
assert int(uid) > 1046

realname = raw_input("Real name: ")

username = raw_input("Username: ")
assert not re.search(r'[^A-Za-z0-9\-]', username)

dn = lib.build_dn(username)
attrs = {
        'uid': [username],
        'cn': [realname],
        'objectClass': ['account', 'posixAccount', 'top',
                        'shadowAccount', 'vtluugPerson'],
        'userPassword': ["{{SASL}}{0}@VTLUUG.ORG".format(username)],
        'shadowLastChange': ['14996'],
        'shadowMax': ['99999'],
        'shadowWarning': ['7'],
        'loginShell': ['/bin/bash'],
        'uidNumber': [uid],
        'gidNumber': ['100'],
        'homeDirectory': ["/home/" + username],
        'gecos': ["{realname},,,".format(realname=realname)],
        'mail': "{username}@vtluug.org".format(username=username),
        }

l = lib.connect()
l.add_s(dn, ldap.modlist.addModlist(attrs))

l.modify_s('cn=members,ou=Groups,dc=vtluug,dc=org',  [
        (ldap.MOD_ADD, 'memberUid', username),
    ])

print("""\
LDAP account created!
Now create a Kerberos principal for this user so authentication will work.

ssh you@blade.vtluug.org
sudo kadmin.local
addprinc {username}

In the future this process will be automated.
""".format(username=username))

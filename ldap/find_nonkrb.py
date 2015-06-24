#!/usr/bin/python2
###############################################################################
# find_nonkrb.py - find users that have not migrated to kerberos
#
# author: mutantmonkey <mutantmonkey@mutantmonkey.in>
###############################################################################

import ldap
import lib

l = lib.connect()

results = l.search_s('ou=People,dc=vtluug,dc=org', ldap.SCOPE_SUBTREE)
for result in results:
    props = dict(result[1])
    if 'userPassword' not in props:
        continue
    if not props['userPassword'][0].startswith('{SASL}'):
        print(result[0])

#!/usr/bin/python2
###############################################################################
# manage.py - Manage LDAP accounts
#
# author: mutantmonkey <mutantmonkey@mutantmonkey.in>
###############################################################################

import argparse
import copy
import ldap
import ldap.modlist
import lib
import re
import sys

LOCKOUT_DN = "cn=noshell,ou=Groups,dc=vtluug,dc=org"


def manage_users(args):
    l = lib.connect()

    for username in args.username:
        dn = lib.build_dn(username)

        try:
            result = l.search_s(dn, ldap.SCOPE_SUBTREE)
        except ldap.NO_SUCH_OBJECT:
            print("Error: {0} does not exist in LDAP.".format(username))
            continue

        if args.lock:
            result = l.search_s(LOCKOUT_DN, ldap.SCOPE_SUBTREE)
            oldattrs = result[0][1]
            attrs = copy.deepcopy(oldattrs)
            if not 'memberUid' in attrs:
                attrs['memberUid'] = []

            if username in attrs['memberUid']:
                print("Error: {0} is already locked out.".format(username))
                continue

            attrs['memberUid'].append(username)

            modlist = ldap.modlist.modifyModlist(oldattrs, attrs)
            l.modify_s(LOCKOUT_DN, modlist)

            print("{0}: account locked.".format(username))
        elif args.unlock:
            result = l.search_s(LOCKOUT_DN, ldap.SCOPE_SUBTREE)
            oldattrs = result[0][1]
            attrs = copy.deepcopy(oldattrs)
            if not 'memberUid' in attrs:
                attrs['memberUid'] = []

            if not username in attrs['memberUid']:
                print("Error: {0} is not locked out.".format(username))
                continue

            attrs['memberUid'].remove(username)

            modlist = ldap.modlist.modifyModlist(oldattrs, attrs)
            l.modify_s(LOCKOUT_DN, modlist)

            print("{0}: account unlocked.".format(username))
        elif args.enable_shell:
            oldattrs = result[0][1]
            if 'posixAccount' in oldattrs['objectClass']:
                print("Error: {0} already has shell access.".format(username))
                continue

            # FIXME: blank = auto increment
            uid = raw_input("UID for {0}: ".format(username))
            assert int(uid) > 1046

            attrs = oldattrs.copy()
            attrs.update({
                    'loginShell': ['/bin/bash'],
                    'uidNumber': [uid],
                    'gidNumber': ['100'],
                    'homeDirectory': ["/home/" + username],
                    'gecos': ["{realname},,,".format(
                        realname=oldattrs['cn'][0])],
                    })

            modlist = ldap.modlist.modifyModlist(oldattrs, attrs)
            modlist.append((ldap.MOD_ADD, 'objectClass', 'posixAccount'))
            l.modify_s(dn, modlist)

            print("{0} now has shell access.".format(username))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="Manage LDAP accounts.")
    group = parser.add_mutually_exclusive_group()
    group.add_argument('--enable-shell', action='store_true',
            help="Enable shell access for the specified LDAP accounts.")
    group.add_argument('-l', '--lock', action='store_true',
            help="Lock out the specified LDAP accounts.")
    group.add_argument('-u', '--unlock', action='store_true',
            help="Unlock the specified LDAP accounts.")
    parser.add_argument('username', type=str, nargs='+')
    args = parser.parse_args()

    manage_users(args)

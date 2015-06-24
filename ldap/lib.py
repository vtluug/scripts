###############################################################################
# lib.py - common methods for LDAP scripts
#
# author: mutantmonkey <mutantmonkey@mutantmonkey.in>
###############################################################################

import ldap
import ldap.dn
import ldap.sasl
import random

LDAP_URI = "ldap://ldap.vtluug.org"

alpha = 'abcdefghijklmnopqrstuvwxyz'
saltchars = alpha + alpha.upper() + '01234556789./'


def mksalt():
    # we only support sha256 salts for now
    s = '$6$'
    s += ''.join(random.choice(saltchars) for _ in range(8))
    return s


def build_dn(username):
    dn = "uid={username},ou=People,dc=vtluug,dc=org".format(
            username=ldap.dn.escape_dn_chars(username))
    return dn


def connect():
    l = ldap.initialize(LDAP_URI)
    l.set_option(ldap.OPT_X_TLS_DEMAND, True)
    l.sasl_interactive_bind_s('', ldap.sasl.gssapi(''))
    return l

#!/usr/bin/perl -w
# Convert public keys from and to the format used by Racoon.
# Written and placed in the public domain by Andreas Voegele.

use strict;

use Parse::RecDescent;
use Crypt::OpenSSL::RSA;
use MIME::Base64;

sub pem2rfc {
    my $key = shift;
    my $rsa_pub = Crypt::OpenSSL::RSA->new_public_key($key);
    my ($n, $e) = $rsa_pub->get_key_parameters();
    my $eb = $e->to_bin();
    return encode_base64(pack("C", length($eb)) . $eb . $n->to_bin(), '');
}

sub rfc2pem {
    my $key = shift;
    my $decoded = decode_base64($key);
    my $len = unpack("C", substr($decoded, 0, 1));
    my $e = Crypt::OpenSSL::Bignum->new_from_bin(substr($decoded, 1, $len));
    my $n = Crypt::OpenSSL::Bignum->new_from_bin(substr($decoded, 1 + $len));
    my $rsa_pub = Crypt::OpenSSL::RSA->new_key_from_parameters($n, $e);
    return $rsa_pub->get_public_key_x509_string();
}

my $grammar = q {
    input: item(s)
    item: pempubkey | rfcpubkey | other
    pempubkey: m{-----BEGIN PUBLIC KEY-----.*?-----END PUBLIC KEY-----}s
               { print ": PUB 0s" . ::pem2rfc($item[1]), "\n"; }
    rfcpubkey: addr(0..2) ':' 'PUB' m{0s[A-Za-z0-9+/=]+}
               { print ::rfc2pem(substr($item[4], 2)); }
    addr: ( ipv4addr | ipv6addr ) <skip: ''> prefix(?) | 'any'
    ipv4addr: /(?:\\d{1,3}\\.){3}\\d{1,3}/
    ipv6addr: /[[:xdigit:]:]*:[[:xdigit:]:]*:[[:xdigit:]:]*/
    prefix: m{/\d{1,3}}
    other: /.*/
};

my $parser = new Parse::RecDescent($grammar);
undef $/;
my $input = <>;
$parser->input($input);
#!/usr/bin/env puppet
#
# -*- mode: puppet; sh-basic-offset: 4; indent-tabs-mode: nil; coding: utf-8 -*-
# vim:set tabstop=4 softtabstop=4 expandtab shiftwidth=4 fileencoding=utf-8:
#

define nginx::vhost($content='', $source='', $ensure='present') {
    if (($content and $source) or (!$content and !$source)){
        err('Must define "content" or "source" for nginx::vhost!')
        fail('Must define "content" or "source" for nginx::vhost!')
    }

    case $ensure {
        'present': {
            $ensure_file = 'present'
            $ensure_link = 'absent'
        }
        'enabled': {
            $ensure_file = 'present'
            $ensure_link = 'present'
        }
        'absent', 'purged': {
            $ensure_file = 'absent'
            $ensure_link = 'absent'
        }
        default: {
            err("Invalid value for 'ensure' (valid values: present, purged, absent): $ensure")
            fail("Invalid value for 'ensure': $ensure")
        }
    }

    $vhost_name = $name

    File {
        require => [
            File['/etc/nginx/sites-available'],
            File['/etc/nginx/sites-enabled'],
        ],
        mode    => 0644,
        notify  => Exec['nginx::reload'],
    }

    file {
        "/etc/nginx/sites-available/${vhost_name}.conf":
            ensure  => $ensure_file,
            content => $content ? {
                ''      => undef,
                default => $content,
            },
            source  => $source ? {
                ''      => undef,
                default => $source,
            };
        "/etc/nginx/sites-enabled/${vhost_name}.conf":
            ensure => $ensure_link ? {
                'absent'    => 'absent',
                default     => 'link',
            },
            target => "/etc/nginx/sites-available/${vhost_name}.conf";
    }
}

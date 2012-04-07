# -*- mode: puppet; sh-basic-offset: 4; indent-tabs-mode: nil; coding: utf-8 -*-
# vim: tabstop=4 softtabstop=4 expandtab shiftwidth=4 fileencoding=utf-8

define nginx::config($content='', $source='', $order='500', $ensure='present') {

    if (($content and $source) or (!$content and !$source)){
        err('Must define "content" or "source" for nginx::config!')
        fail('Must define "content" or "source" for nginx::config!')
    }

    case $ensure {
        'present': {
            $ensure_real = 'present'
        }
        'absent', 'purged': {
            $ensure_real = 'purged'
        }
        default: {
            err("Invalid value for 'ensure' (valid values: present, purged, absent): $ensure")
            fail("Invalid value for 'ensure': $ensure")
        }
    }

    $config_name = $name

    File {
        require => File['/etc/nginx/conf.d'],
        mode    => 0644,
        notify  => Exec['nginx::reload'],
    }

    file {
        "/etc/nginx/conf.d/${order}-${config_name}.conf":
            ensure  => $ensure_real,
            content => $content ? {
                ''      => undef,
                default => $content,
            },
            source  => $source ? {
                ''      => undef,
                default => $source,
            };
    }
}


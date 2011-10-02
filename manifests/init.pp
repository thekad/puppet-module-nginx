# -*- mode: puppet; sh-basic-offset: 4; indent-tabs-mode: nil; coding: utf-8 -*-
# vim: tabstop=4 softtabstop=4 expandtab shiftwidth=4 fileencoding=utf-8

class nginx {

    include nginx::params

    group {
        "${nginx::params::run_as_group}":
            ensure => present;
    }

    user {
        "${nginx::params::run_as_user}":
            ensure     => present,
            gid        => $nginx::params::run_as_group,
            comment    => 'NGINX System User',
            home       => '/srv/www',
            managehome => false,
            shell      => '/bin/false',
            before     => Service['nginx'];
    }

    package {
        'nginx':
            ensure  => installed,
            notify  => Exec['nginx::upgrade'],
            require => User[$nginx::params::run_as_user];
    }

    if ! defined(Package['logrotate']) {
        package {
            'logrotate':
                ensure => installed;
        }
    }

    File {
        require => Package['nginx'],
        before  => Service['nginx'],
    }

    file {
        '/etc/nginx':
            ensure  => directory;
        '/etc/nginx/nginx.conf':
            content => template('nginx/nginx.conf.erb'),
            notify  => Exec['nginx::reload'];
        '/etc/nginx/conf.d':
            ensure  => directory,
            recurse => true,
            purge   => true;
        '/etc/nginx/sites-available':
            ensure => directory;
        '/etc/nginx/sites-enabled':
            ensure => directory;
        '/etc/nginx/fastcgi_params':
            source => 'puppet:///modules/nginx/fastcgi_params';
        '/etc/nginx/scgi_params':
            source => 'puppet:///modules/nginx/scgi_params';
        '/etc/nginx/uwsgi_params':
            source => 'puppet:///modules/nginx/uwsgi_params';
        '/etc/nginx/mime.types':
            source => 'puppet:///modules/nginx/mime.types';
        '/var/log/nginx':
            ensure => directory,
            owner  => $nginx::params::run_as_user,
            group  => $nginx::params::run_as_group,
            mode   => 0750;
        '/etc/logrotate.d/nginx':
            content => template('nginx/logrotate.conf.erb'),
            require => Package['logrotate'];
    }

    service {
        'nginx':
            ensure  => running,
            enable  => true;
    }

    exec {
        'nginx::reload':
            command     => $nginx::params::reload_cmd,
            refreshonly => true;
        'nginx::upgrade':
            command     => $nginx::params::upgrade_cmd,
            refreshonly => true;
    }

    nginx::config {
        'default':
            order   => '00',
            content => template('nginx/default.conf.erb');
    }
}


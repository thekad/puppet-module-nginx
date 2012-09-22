# -*- mode: puppet; sh-basic-offset: 4; indent-tabs-mode: nil; coding: utf-8 -*-
# vim: tabstop=4 softtabstop=4 expandtab shiftwidth=4 fileencoding=utf-8

class nginx::params {

#   If you wish to install a specific version, define it at the node level
    $install_version = $node_install_version ? {
        ''      => installed,
        default => $node_install_version,
    }

    case $operatingsystem {
        'ubuntu', 'debian': {
            $run_as_user = 'www-data'
            $run_as_group = 'adm'
            $reload_cmd = '/usr/sbin/service nginx reload'
#           Ubuntu doesn't support upgrade in place
            $upgrade_cmd = '/bin/false'
            $default_root_dir = '/usr/share/nginx/www'
        }
        'redhat', 'centos', 'fedora': {
            $run_as_user = 'nginx'
            $run_as_group = 'root'
            $reload_cmd = '/sbin/service nginx reload'
            $upgrade_cmd = '/sbin/service nginx upgrade'
            $default_root_dir = '/usr/share/nginx/html'
        }
    }
}


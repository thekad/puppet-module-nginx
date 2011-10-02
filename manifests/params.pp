class nginx::params {

    case $operatingsystem {
        'ubuntu', 'debian': {
            $run_as_user = 'www-data'
            $run_as_group = 'adm'
            $reload_cmd = '/usr/sbin/service nginx reload'
#           Ubuntu doesn't support upgrade in place
            $upgrade_cmd = '/bin/false'
        }
        'redhat', 'centos', 'fedora': {
            $run_as_user = 'nginx'
            $run_as_group = 'root'
            $reload_cmd = '/sbin/service nginx reload'
            $upgrade_cmd = '/sbin/service nginx upgrade'
        }
    }
}


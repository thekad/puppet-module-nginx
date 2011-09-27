class nginx::params {

    case $operatingsystem {
        'ubuntu', 'debian': {
            $run_as = 'www-data'
        }
        'redhat', 'centos', 'fedora': {
            $run_as = 'nginx'
        }
    }
}


class nginx {

    include nginx::params

    package {
        'nginx':
            ensure => installed;
    }

    File {
        require => Package['nginx'],
        before  => Service['nginx'],
    }

    file {
        '/etc/nginx':
            ensure => directory;
        '/etc/nginx/nginx.conf':
            content => template('nginx/nginx.conf.erb');
        '/etc/nginx/conf.d':
            ensure => directory;
        '/etc/nginx/sites-available':
            ensure => directory;
        '/etc/nginx/sites-enabled':
            ensure => directory;
        '/etc/nginx/fastcgi_params':
            source => 'puppet:///modules/nginx/fastcgi_params'
        '/etc/nginx/scgi_params':
            source => 'puppet:///modules/nginx/scgi_params'
        '/etc/nginx/uwsgi_params':
            source => 'puppet:///modules/nginx/uwsgi_params'
        '/etc/nginx/mime.types':
            source => 'puppet:///modules/nginx/mime.types'
    }

    service {
        'nginx':
            ensure  => running,
            enable  => true,
            require => Package['nginx'];
    }
}


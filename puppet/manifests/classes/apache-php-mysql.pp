############################
# eZ Publish Puppet Config #
############################
# OS          : Linux      #
# Database    : MySQL 5    #
# Web Server  : Apache 2   #
# PHP version : 5.3        #
############################

#include apache
include php
include mysql
include stdlib
include puppi

# Apache Setup
##############

class { 'apache':
  mpm_module => 'prefork',
}

apache::mod { 'php5': }
apache::mod {'rewrite': }

apache::vhost { $fqdn:
    priority => '20',
    port => '80',
    docroot => $docroot,
    override => "All"
}


# PHP Extensions
################
php::module { [ 'bz2', 'curl', 'dom', 'exif', 'fileinfo', 'ftp', 'gd', 'iconv', 'json', 'mbstring', 'mysqli', 'pcntl', 'pcre', 'pdo-mysql', 'posix', 'reflection', 'simplexml', 'spl', 'ssl', 'xmlreader', 'zlib', 'xml', 'libxml', 'xsl' ] :
	notify => [Service['httpd'], ],
}

augeas { "php.ini":
	notify 	=> Service[httpd],
	require => Package[php],
	context => "/files/etc/php.ini/PHP",
	changes => [
		"set post_max_size 10M",
		"set upload_max_filesize 10M",
		"set date.timezone Europe\\Paris",
		"set memory_limit 256M",
		"set max_execution_time 300",
		"set display_errors On",
		"set error_reporting E_ALL | E_STRICT"
	]
}

# MySQL Server
##############
class { 'mysql::server':
    config_hash => { 'root_password' => 'root' }
}

mysql::db { 'ezpublish':
	user		=> 'ezpublish',
	password 	=> 'publish',
	host		=> 'localhost',
	grant		=> ['all'],
	charset 	=> 'utf8',
}

# Other Packages
################
$extras = ['vim', 'phpunit']
package { $extras: ensure => 'installed' }

# Check if all are okay
########################
file { $docroot:
	ensure => 'directory',
}

#class { 'ntp':
#	ensure => 'running',
#}

# Zone de test
##############
ezpublish::install { 'eZ Publish Community Project 2013.4':
    src  => 'http://share.ez.no/content/download/149574/883017/version/1/file/ezpublish5_community_project-2013.4-gpl-full.tar.gz',
    dest => '/var/www'
}

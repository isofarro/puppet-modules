# TODO: Separate into modules.


#
# Base install
#
exec { 'aptupdate':
	command => '/usr/bin/apt-get update',
	user    => 'root',
}

package { 'core-packages':
	name => [
		'wget',
		'curl',
		'vim',
		'git-core',
		'htop',
	],
	ensure  => installed,
	require => Exec['aptupdate'],
}


#
# PHP5 environment
#
package { 'php5-cli':
	ensure  => installed,
	require => Package['core-packages'],
}


#
# Beanstalk
#
package { 'beanstalkd':
	ensure  => installed,
	require => Package['core-packages'],
}

file { '/etc/default/beanstalkd':
	ensure  => present,
	source  => 'puppet:///modules/beanstalk/beanstalkd.conf',
	owner   => 'root',
	group   => 'root',
	mode    => '644',
	notify  => Service['beanstalkd'],
	require => Package['beanstalkd'],
}

service { 'beanstalkd':
	ensure     => running,
	enable     => true,
	hasrestart => true,
	hasstatus  => true,
	require    => Package['beanstalkd'],
}


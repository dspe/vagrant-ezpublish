class linux_common {
	exec { "apt-update":
	    command => "/usr/bin/apt-get update"
	}
	# Require apt-update for every Package command
	Exec["apt-update"] -> Package <| |>
	Package["puppet"] -> Augeas <| |>
	Package['libaugeas-ruby'] -> Augeas <| |>

	# replace puppet and ruby so we can use augeas for file config
	package { libaugeas-ruby:
		ensure => installed,
	}

	package { augeas-tools:
		ensure => installed,
	}
	package { puppet:
			ensure => installed,
	}

	package { make:
		ensure => installed,
	}
}
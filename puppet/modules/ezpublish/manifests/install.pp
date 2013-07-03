#
# Download, extract and ready for eZ Setup
#
define ezpublish::install(
	$src,	# Url or file path
	$dest	# Where to install files
)
{
	$filename = inline_template('<%= File.basename(src) %>')
	$version_archive = '/var/www'
	
	file { "${version_archive}/${filename}":
		ensure => present,		
	}
	
	if ($src =~ /^http(|s):\/\// )
	{
		# Download to local archive
		download_file { $filename:
			src		=> $src,
			dest	=> $version_archive,
			require => File[$version_archive],
			#notify	=> Extract_file["${version_archive}/${filename}"],
		}
	} else {
		# Copy to local archive
	}
}

# Utility
define download_file (
	$src,
	$dest
)
{
	$filename = inline_template('<%= File.basename(src) %>')
	exec { "Download ${src} to ${dest}":
		command => "wget ${src} -O ${dest}/${filename}",
		creates => "${dest}/${filename}",
	}
}
# Class to deploy init script and service management for uwsgi
class uwsgi::service (
  Optional[Boolean] $manage_file,
  Optional[Stdlib::Absolutepath] $file,
  Optional[String[4,4]] $file_mode, # TODO: check via regex
  Optional[String[1]] $template,
  Optional[String[1]] $provider,
  Optional[Boolean] $ensure,
  Optional[Boolean] $enable,
  # template variables
  Optional[Stdlib::Absolutepath] $binary_directory,
  Optional[Stdlib::Absolutepath] $configfile = lookup('uwsgi::config::configfile'),
  Optional[Stdlib::Absolutepath] $logfile = lookup('uwsgi::config::logfile'),
  Optional[Stdlib::Absolutepath] $pidfile = lookup('uwsgi::config::pidfile'),
  Optional[Stdlib::Absolutepath] $socket = lookup('uwsgi::config::socket'),
) {
  if $manage_file == true {
    $file_ensure = $ensure ? {
      true    => 'present',
      default => 'absent'
    }
    file { $file:
      ensure  => $file_ensure,
      owner   => 'root',
      group   => 'root',
      mode    => $file_mode,
      replace => $manage_file,
      content => template($template),
    }
  }
  service { 'uwsgi':
    ensure    => $ensure,
    enable    => $enable,
    provider  => $provider,
    subscribe => File[$configfile],
  }
}

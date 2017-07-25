# https://collectd.org/wiki/index.php/Plugin:FileCount
define collectd::plugin::filecount::directory (
  $ensure        = 'present',
  $instance      = $name,
  $path          = undef,
  $pattern       = undef,
  $mtime         = undef,
  $size          = undef,
  $recursive     = undef,
  $includehidden = undef
) {

  include ::collectd
  include ::collectd::plugin::filecount

  $conf_dir = $collectd::plugin_conf_dir

  validate_string($path)

  file { "${conf_dir}/15-filecount-${name}.conf":
    ensure  => $ensure,
    mode    => '0640',
    owner   => 'root',
    group   => $collectd::root_group,
    content => template('collectd/plugin/filecount-directory.conf.erb'),
    notify  => Service['collectd_service'],
  }
}

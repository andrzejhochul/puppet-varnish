class varnish::ncsa (
  $enable = true,
  $varnishncsa_daemon_opts = undef,
) {

  if  $::operatingsystem =~ /(?i:Centos|RedHat|OracleLinux)/ and 
      $::operatingsystemmajrelease >= 7 {
    file { '/usr/lib/systemd/system/varnishncsa.service':
      ensure  => 'present',
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      content => template('varnish/varnishncsa-systemd.erb'),
      notify  => Service['varnishncsa'],
    }

    file { '/etc/sysconfig/varnishncsa':
      ensure  => 'present',
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      content => template('varnish/varnishncsa-params.erb'),
      notify  => Service['varnishncsa'],
    }
  } else {
    file { '/etc/default/varnishncsa':
      ensure  => 'present',
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      content => template('varnish/varnishncsa-default.erb'),
      notify  => Service['varnishncsa'],
    }
  }

  $service_ensure = $enable ? {
    true => 'running',
    default => 'stopped',
  }

  service { 'varnishncsa':
    ensure    => $service_ensure,
    enable    => $enable,
    require   => Service['varnish'],
  }

}

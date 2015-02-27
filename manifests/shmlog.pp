# == Class: varnish::shmlog
#
# Mounts shmlog as tempfs
#
# === Parameters
#
# shmlog_dir      - directory where Varnish logs
#
# tempfs          - mount or not shmlog as tmpfs, boolean
#                   default value: true
#
# selinux_support - set the selinux context on the tmpfs to allow
#                   varnish to write to it
#
# === Examples
#
# disable config for mounting shmlog as tmpfs
# class {'varnish::shmlog':
#   tempfs => false,
# }
#

class varnish::shmlog (
  $shmlog_dir      = '/var/lib/varnish',
  $tempfs          = true,
  $selinux_support = false,
) {

  file { 'shmlog-dir':
    ensure  => directory,
    path    => $shmlog_dir,
  }

  # mount shared memory log dir as tmpfs
  $shmlog_share_state = $tempfs ? {
    true    => mounted,
    default => absent,
  }

  $options = $selinux_support ? {
    true    => 'defaults,noatime,size=128M,context=system_u:object_r:varnishd_var_lib_t:s0',
    default => 'defaults,noatime,size=128M',
  }

  mount { 'shmlog-mount':
    ensure  => $shmlog_share_state,
    name    => $shmlog_dir,
    target  => '/etc/fstab',
    fstype  => 'tmpfs',
    device  => 'tmpfs',
    options => $options,
    pass    => '0',
    dump    => '0',
    require => File['shmlog-dir'],
  }
}

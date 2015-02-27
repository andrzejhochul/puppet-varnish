require 'spec_helper'

describe 'varnish::shmlog', :type => :class do
  context "default values" do

    it { should compile }
    it { should contain_file('shmlog-dir').with(
      'ensure' => 'directory',
       'path'  => '/var/lib/varnish'
      )
    }
    it { should contain_mount('shmlog-mount').with(
        'target'  => '/etc/fstab',
        'fstype'  => 'tmpfs',
        'device'  => 'tmpfs',
        'options' => 'defaults,noatime,size=128M'
      )
    }

  end

  context "with SELinux support" do
    let(:params) {{ :selinux_support => true }}

    it { should contain_file('shmlog-dir').with(
      'ensure' => 'directory',
       'path'  => '/var/lib/varnish'
      )
    }
    it { should contain_mount('shmlog-mount').with(
        'target'  => '/etc/fstab',
        'fstype'  => 'tmpfs',
        'device'  => 'tmpfs',
        'options' => 'defaults,noatime,size=128M,context=system_u:object_r:varnishd_var_lib_t:s0',
      )
    }

  end
  
  context "disable mount" do
    let(:params) {{ :tempfs => false}}

    it { should contain_mount('shmlog-mount').with(
        'ensure'  => 'absent',
        'target'  => '/etc/fstab',
        'fstype'  => 'tmpfs',
        'device'  => 'tmpfs',
        'options' => 'defaults,noatime,size=128M'
      )
    }

  end

end

require 'spec_helper'

describe 'varnish::ncsa', :type => :class do
  let :pre_condition do
    'include varnish'
  end

  context 'default values' do
    it { should compile }
    it { should contain_file('/etc/default/varnishncsa').with(
      'ensure'  => 'present',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0644',
      'notify'  => 'Service[varnishncsa]'
      )
    }
    it { should contain_file('/etc/default/varnishncsa').with_content(/VARNISHNCSA_ENABLED=1/) }
    it { should contain_file('/etc/default/varnishncsa').without_content(/DAEMON_OPTS/) }
    it { should contain_service('varnishncsa').with(
      'ensure'    => 'running',
      'require'   => 'Service[varnish]',
      )
    }
  end
  
  context 'with enable false' do
    let(:params) { { :enable => false } }
    it { should contain_file('/etc/default/varnishncsa').with_content(/# VARNISHNCSA_ENABLED=1/) }
    it { should contain_service('varnishncsa').with('ensure' => 'stopped') }      
  end
  
  context 'on el7' do
    let :facts do
     {
       :operatingsystem           => 'RedHat',
       :operatingsystemmajrelease => 7,
     }
    end
    it { should contain_file('/etc/sysconfig/varnishncsa').with_content(/DAEMON_OPTS=""/) }
    it { should contain_file('/usr/lib/systemd/system/varnishncsa.service').with_content(/ExecStart/) }
    it { should contain_service('varnishncsa').with('ensure' => 'running') }      
    
    context 'with daemon options set' do
      let (:params) {{ :varnishncsa_daemon_opts => '-F \'%h %l %u %t %s %b %{Referer}i %{User-agent}i %{Varnish:time_firstbyte}x\'' }}
      
    it { should contain_file('/etc/sysconfig/varnishncsa').with_content(/DAEMON_OPTS="-F '%h %l %u %t %s %b %{Referer}i %{User-agent}i %{Varnish:time_firstbyte}x'"/) }
    end
  end

  context 'on el6 should use standard init script' do
    let :facts do
     {
       :operatingsystem           => 'RedHat',
       :operatingsystemmajrelease => 6,
     }
    end
    it { should contain_file('/etc/default/varnishncsa').with_content(/VARNISHNCSA_ENABLED=1/) }
    it { should contain_file('/etc/default/varnishncsa').without_content(/DAEMON_OPTS/) }
    it { should contain_service('varnishncsa').with(
      'ensure'    => 'running',
      'require'   => 'Service[varnish]',
      )
    }
  end
end

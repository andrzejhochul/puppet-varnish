require 'spec_helper'

describe 'varnish::backend', :type => :define do
  let :pre_condition do
    'class { "::varnish::vcl": }'
  end
    
  let(:facts) { { :concat_basedir => '/dne' } }
  let(:title) { 'test' }
  
  context("expected behaviour when host specified as IP") do
    let(:params) { { :host => '192.168.10.14', :port => '8080' } }
    it { should contain_file('/etc/varnish/includes/backends.vcl') }
    it { should contain_concat__fragment('test-backend') }
  end

  context("expected behaviour when host specified as hostname") do
    let(:params) { { :host => 'localhost', :port => '8080' } }
    it { should contain_file('/etc/varnish/includes/backends.vcl') }
    it { should contain_concat__fragment('test-backend') }
  end
  
  context("invalid host IP") do
    let(:params) { { :host => '123.456', :port => '8080' } }
    it 'should cause a failure' do
      expect {should compile }.to raise_error(RSpec::Expectations::ExpectationNotMetError, /Backend host 123.456 is not an IP Address or hostname!/)
    end    
  end

  context("invalid hostname") do
    let(:params) { { :host => 'im not a valid_hostname', :port => '8080' } }
    it 'should cause a failure' do
      expect {should compile }.to raise_error(RSpec::Expectations::ExpectationNotMetError, /Backend host im not a valid_hostname is not an IP Address or hostname!/)
    end    
  end

  context("invalid backend title") do
    let(:params) { { :host => 'localhost', :port => '8080' } }
    let(:title) { '-invalid-title' }
    it 'should cause a failure' do
      expect {should compile }.to raise_error(RSpec::Expectations::ExpectationNotMetError, /Invalid characters in backend name -invalid-title. Only letters, numbers and underscore are allowed./)
    end    
  end

end

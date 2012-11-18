#!/usr/bin/env rspec

require 'spec_helper'

describe 'func::minion', :type => 'class' do

  context 'on a non-supported operatingsystem' do
    let :facts do {
      :osfamily        => 'foo',
      :operatingsystem => 'bar'
    }
    end
    it 'should fail' do
      expect {
        should raise_error(Puppet::Error, /Unsupported platform: foo/)
      }
    end
  end

  context 'on a supported operatingsystem, default parameters' do
    let(:params) {{}}
    let :facts do {
      :osfamily        => 'RedHat',
      :operatingsystem => 'CentOS'
    }
    end
    it { should contain_file('/etc/func/minion.conf').with(
      :ensure => 'present',
      :mode   => '0644',
      :owner  => 'root',
      :group  => 'root'
    )}
    it 'should contain File[/etc/func/minion.conf] with contents "listen_addr = "' do
      verify_contents(subject, '/etc/func/minion.conf', [ 'listen_addr = ', ])
    end
    it { should contain_service('funcd').with(
      :ensure     => 'running',
      :enable     => true,
      :hasrestart => true,
      :hasstatus  => false
    )}
  end

  context 'on a supported operatingsystem, custom parameters' do
    let :facts do {
      :fqdn                   => 'testhost',
      :osfamily               => 'RedHat',
      :operatingsystem        => 'CentOS',
      :operatingsystemrelease => '6'
    }
    end

    describe 'ensure => absent' do
      let :params do {
        :ensure => 'absent'
      }
      end
      it { should contain_file('/etc/func/minion.conf').with_ensure('absent') }
      it { should contain_service('funcd').with(
        :ensure => 'stopped',
        :enable => false
      )}
    end

    describe 'listen_addr => 127.0.0.2' do
      let :params do {
        :listen_addr => '127.0.0.2'
      }
      end
      it 'should contain File[/etc/func/minion.conf] with contents "listen_addr = 127.0.0.2"' do
        verify_contents(subject, '/etc/func/minion.conf', [ 'listen_addr = 127.0.0.2', ])
      end
    end

    describe 'use_puppet_certs => true' do
      let :params do {
        :use_puppet_certs => true
      }
      end
      it 'should contain File[/etc/func/minion.conf] with contents "ca_file = /var/lib/puppet/ssl/certs/ca.pem"' do
        verify_contents(subject, '/etc/func/minion.conf', [
          'use_certmaster = 0',
          'cert_file = /var/lib/puppet/ssl/certs/testhost.pem',
          'key_file = /var/lib/puppet/ssl/private_keys/testhost.pem',
          'ca_file = /var/lib/puppet/ssl/certs/ca.pem',
        ])
      end
    end

    describe 'puppetmaster_ssl_dir => /etc/puppetlabs/puppet' do
      let :params do {
        :puppetmaster_ssl_dir => '/etc/puppetlabs/puppet',
        :use_puppet_certs     => true
      }
      end
      it 'should contain File[/etc/func/minion.conf] with contents "ca_file = /etc/puppetlabs/puppet/ssl/certs/ca.pem"' do
        verify_contents(subject, '/etc/func/minion.conf', [
          'use_certmaster = 0',
          'cert_file = /etc/puppetlabs/puppet/ssl/certs/testhost.pem',
          'key_file = /etc/puppetlabs/puppet/ssl/private_keys/testhost.pem',
          'ca_file = /etc/puppetlabs/puppet/ssl/certs/ca.pem',
        ])
      end
    end

    describe '$service_ensure => stopped; service_enable => false' do
      let :params do {
        :service_ensure => 'stopped',
        :service_enable => false
      }
      end
      it { should contain_service('funcd').with(
        :ensure => 'stopped',
        :enable => false
      )}
    end
  end

end

#!/usr/bin/env rspec

require 'spec_helper'

describe 'func::overlord', :type => 'class' do

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
    let(:pre_condition) { 'class {"certmaster":}' }
    let :facts do {
      :osfamily        => 'RedHat',
      :operatingsystem => 'CentOS'
    }
    end
    it { should contain_file('/etc/func/overlord.conf').with(
      :ensure => 'present',
      :mode   => '0644',
      :owner  => 'root',
      :group  => 'root'
    )}
    it 'should contain File[/etc/func/overlord.conf] with contents "# configuration for overlord"' do
      verify_contents(subject, '/etc/func/overlord.conf', [ '# configuration for overlord', ])
    end
    # TODO: negate verify_contents
    it { should_not contain_file('/etc/func/overlord.conf').with_content(/^puppet_minions = True$/) }
    it { should contain_file('/etc/func/groups').with(
      :ensure => 'present',
      :mode   => '0644',
      :owner  => 'root',
      :group  => 'root'
    )}
  end

  context 'on a supported operatingsystem, custom parameters' do
    let(:pre_condition) { 'class {"certmaster":}' }
    let :facts do {
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
      it { should contain_file('/etc/func/overlord.conf').with_ensure('absent') }
      it { should contain_file('/etc/func/groups').with_ensure('absent') }
    end

    describe 'use_puppet_certs => true' do
      let :params do {
        :use_puppet_certs => true
      }
      end
      it 'should contain File[/etc/func/overlord.conf] with contents "ca_file = /var/lib/puppet/ssl/certs/ca.pem"' do
        verify_contents(subject, '/etc/func/overlord.conf', [
          'puppet_minions = True',
          'ca_file = /var/lib/puppet/ssl/certs/ca.pem',
          'crl_location = /var/lib/puppet/ssl/crl.pem',
          'cert_file = /var/lib/puppet/ssl/certs/ca.pem',
          'key_file = /var/lib/puppet/ssl/ca/ca_key.pem',
        ])
      end
    end

    describe 'puppetmaster_ssl_dir => /etc/puppetlabs/puppet' do
      let :params do {
        :puppetmaster_ssl_dir => '/etc/puppetlabs/puppet',
        :use_puppet_certs     => true
      }
      end
      it 'should contain File[/etc/func/overlord.conf] with contents "ca_file = /etc/puppetlabs/puppet/ssl/certs/ca.pem"' do
        verify_contents(subject, '/etc/func/overlord.conf', [
          'puppet_minions = True',
          'ca_file = /etc/puppetlabs/puppet/ssl/certs/ca.pem',
          'crl_location = /etc/puppetlabs/puppet/ssl/crl.pem',
          'cert_file = /etc/puppetlabs/puppet/ssl/certs/ca.pem',
          'key_file = /etc/puppetlabs/puppet/ssl/ca/ca_key.pem',
        ])
      end
    end
  end

end

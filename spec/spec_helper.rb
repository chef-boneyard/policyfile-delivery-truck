require 'chefspec'
# here lies the fur of many yaks
# TLDR: https://github.com/chefspec/chefspec/issues/718
ENV['BERKSHELF_CHEF_CONFIG'] = '/dev/null'
require 'chefspec/berkshelf'
require 'aws-sdk'

TOPDIR = __dir__
$LOAD_PATH << __dir__

# Require all our libraries
Dir['libraries/*.rb'].each { |f| require File.expand_path(f) }

module SharedLetDeclarations
  extend RSpec::SharedContext

  let(:no_changed_cookbooks) { [] }

  let(:fake_delivery_chef_server) do
    {
      chef_server_url: 'http://chef.example.com/organizations/orgname',
      options: {
        client_name: 'spec',
        signing_key_filename: '/tmp/keys/spec.pem',
      },
    }
  end

  # Simple chef run with default delivery values
  # To use it, put the following in your test:
  # let(:chef_run) { chef_runner.converge(described_recipe) }
  let(:chef_runner) do
    ChefSpec::SoloRunner.new do |node|
      node.default['delivery']['workspace_path'] = "#{TOPDIR}/fixtures"
      node.default['delivery']['workspace']['repo'] = "#{TOPDIR}/fixtures/repo"
      node.default['delivery']['workspace']['chef'] = "#{TOPDIR}/fixtures/chef"
      node.default['delivery']['workspace']['cache'] = "#{TOPDIR}/fixtures/cache"
      node.default['delivery_builder']['build_user'] = ENV['USER']

      node.default['delivery']['change']['enterprise'] = 'Chef'
      node.default['delivery']['change']['organization'] = 'Delivery'
      node.default['delivery']['change']['project'] = 'Secret'
      node.default['delivery']['change']['pipeline'] = 'master'
      node.default['delivery']['change']['change_id'] = 'aaaa-bbbb-cccc'
      node.default['delivery']['change']['patchset_number'] = '1'
      node.default['delivery']['change']['stage'] = 'union'
      node.default['delivery']['change']['phase'] = 'deploy'
      node.default['delivery']['change']['git_url'] = 'https://git.co/my_project.git'
      node.default['delivery']['change']['sha'] = '0123456789abcdef'
      node.default['delivery']['change']['patchset_branch'] = 'mypatchset/branch'
    end
  end
end

module SharedHelpers
  def pretend_file_exists(filename)
    allow(File).to receive(:exist?).with(filename).and_return(true)
  end

  def pretend_file_is_absent(filename)
    allow(File).to receive(:exist?).with(filename).and_return(false)
  end

  def pretend_directory_exists(filename)
    allow(File).to receive(:directory?).with(filename).and_return(true)
  end

  def pretend_directory_is_absent(filename)
    allow(File).to receive(:directory?).with(filename).and_return(false)
  end

  def default_to_real_file_exists_method
    # This needs to be called before any pretend_file_exists calls so we do
    # real calls for any non-mocked file exists calls.
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:directory?).and_call_original
  end

  def pretend_no_changed_cookbooks
    # This is needed to prevent delivery-truck from trying and failing to work
    # out if there were any changed cookbooks in our (non-existent) repo
    allow_any_instance_of(Chef::Recipe).to receive(:changed_cookbooks).and_return(no_changed_cookbooks)
  end

  def pretend_policy_changed
    # Stubs out the policy_changed? method to make it look like the
    # policyfile.lock has changed from what is on the server
    allow_any_instance_of(Chef::Recipe).to receive(:policy_changed?).and_return(true)
    allow_any_instance_of(Chef::Resource).to receive(:policy_changed?).and_return(true)
    allow_any_instance_of(Chef::Provider).to receive(:policy_changed?).and_return(true)
  end

  def fake_chef_server_fix
    # This puts the node object in the right place so that the delivery sugar
    # stuff surrounding the chef server doesn't try to look in
    # /var/opt/delivery/.chef/knife.rb and fail every time.
    allow_any_instance_of(DeliverySugar::ChefServer).to receive(:node).and_return(chef_runner.node)
  rescue NameError
    true
  end

  alias fake_chef_server fake_chef_server_fix

  def suite_setup
    # Standard things you should do before any tests in a before block
    pretend_no_changed_cookbooks
    default_to_real_file_exists_method
    fake_chef_server_fix
  end
end

RSpec.configure do |config|
  config.include SharedLetDeclarations
  config.include SharedHelpers
  # Skip any tests tagged with :ignore
  config.filter_run_excluding ignore: true
  config.platform = 'ubuntu'
  config.version = '16.04'
end

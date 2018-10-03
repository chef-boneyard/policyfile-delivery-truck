require 'spec_helper'

describe 'policyfile-delivery-truck::provision' do
  before do
    suite_setup
    allow_any_instance_of(Chef::Recipe).to receive(:policy_name).and_return('example')
  end

  let(:chef_run) { chef_runner.converge(described_recipe) }

  context 'when a Policyfile exists in the repo' do
    before do
      pretend_file_exists("#{TOPDIR}/fixtures/repo/Policyfile.rb")
    end

    it 'migrates the policy from a previous environment' do
      expect(chef_run).to run_ruby_block('copy policyfile from prior to current')
    end
  end

  context "when a Policyfile doesn't exist in the repo" do
    before do
      pretend_file_is_absent("#{TOPDIR}/fixtures/repo/Policyfile.rb")
    end

    it "doesn't migrate the policy from a previous environment" do
      expect(chef_run).to_not run_ruby_block('copy policyfile from prior to current')
    end
  end
end

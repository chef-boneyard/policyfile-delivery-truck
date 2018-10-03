require 'spec_helper'

describe 'policyfile-delivery-truck::functional' do
  before { suite_setup }
  let(:chef_run) { chef_runner.converge(described_recipe) }

  context 'when a inspec config exists in the repo' do
    before do
      pretend_file_exists("#{TOPDIR}/fixtures/repo/inspec/default_spec.rb")
    end

    it 'runs inspec' do
      expect(chef_run).to run_execute('functional_inspec').with(
        command: 'inspec exec default_spec.rb',
        cwd: "#{TOPDIR}/fixtures/repo/inspec",
        environment: { 'STAGE' => 'union' }
      )
    end
  end

  context "when a inspec config doesn't exist in the repo" do
    before do
      pretend_directory_is_absent("#{TOPDIR}/fixtures/repo/inspec")
    end

    it "doesn't run inspec" do
      expect(chef_run).to_not run_execute('functional_inspec')
    end
  end
end

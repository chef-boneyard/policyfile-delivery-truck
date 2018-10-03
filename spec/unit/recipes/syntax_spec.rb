require 'spec_helper'

describe 'policyfile-delivery-truck::syntax' do
  before { suite_setup }
  let(:chef_run) { chef_runner.converge(described_recipe) }

  context 'when a policyfile exists in the repo' do
    before do
      pretend_file_exists("#{TOPDIR}/fixtures/repo/Policyfile.rb")
    end

    it 'runs ruby -c against the policyfile' do
      expect(chef_run).to run_execute('syntax_check_Policyfile.rb').with(
        command: 'ruby -c Policyfile.rb',
        cwd: "#{TOPDIR}/fixtures/repo"
      )
    end
  end

  context "when a policyfile doesn't exist in the repo" do
    before do
      pretend_file_is_absent("#{TOPDIR}/fixtures/repo/Policyfile.rb")
    end

    it "doesn't run ruby -c against the policyfile" do
      expect(chef_run).not_to run_execute('syntax_check_Policyfile.rb')
    end
  end
end

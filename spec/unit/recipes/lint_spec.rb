require 'spec_helper'

describe 'policyfile-delivery-truck::lint' do
  before { suite_setup }
  let(:chef_run) { chef_runner.converge(described_recipe) }

  context 'when a policyfile exists in the repo' do
    before do
      pretend_file_exists("#{TOPDIR}/fixtures/repo/Policyfile.rb")
      pretend_file_exists("#{TOPDIR}/fixtures/repo/.rubocop.yml")
    end

    it 'runs rubocop against the policyfile' do
      expect(chef_run).to run_execute('lint_rubocop_Policyfile.rb').with(
        command: 'rubocop Policyfile.rb',
        cwd: "#{TOPDIR}/fixtures/repo"
      )
    end
  end

  context "when a policyfile doesn't exist in the repo" do
    before do
      pretend_file_is_absent("#{TOPDIR}/fixtures/repo/Policyfile.rb")
      pretend_file_exists("#{TOPDIR}/fixtures/repo/.rubocop.yml")
    end

    it "doesn't run rubocop against the policyfile" do
      expect(chef_run).not_to run_execute('lint_rubocop_Policyfile.rb')
    end
  end
end

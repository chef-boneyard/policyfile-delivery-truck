require 'spec_helper'

describe PolicyfileDeliveryTruck::Helpers do
  let(:node) do
    nodee = Chef::Node.new
    nodee.default['delivery']['workspace']['repo'] = "#{TOPDIR}/fixtures/repo"
    nodee
  end

  describe 'repo_path' do
    it 'returns a fully qualified pathname' do
      expect(described_class.repo_path(node, 'foo/bar')).to eql "#{TOPDIR}/fixtures/repo/foo/bar"
    end
  end

  describe 'repo_has_policyfile?' do
    context 'when a policyfile exists' do
      before do
        default_to_real_file_exists_method
        pretend_file_exists("#{TOPDIR}/fixtures/repo/Policyfile.rb")
      end

      it 'returns true' do
        expect(described_class.repo_has_policyfile?(node)).to be true
      end
    end

    context "when a policyfile doesn't exist" do
      before do
        default_to_real_file_exists_method
        pretend_file_is_absent("#{TOPDIR}/fixtures/repo/Policyfile.rb")
      end

      it 'returns true' do
        expect(described_class.repo_has_policyfile?(node)).to be false
      end
    end
  end

  describe 'policy_name' do
    context 'when a policyfile exists' do
      before do
        default_to_real_file_exists_method
        pretend_file_exists("#{TOPDIR}/fixtures/repo/Policyfile.rb")
        # Mock out the file reading without an actual file. This will need to
        # be changed if we do something other than foreach to read the
        # policyfile.
        allow(File).to receive(:foreach).and_call_original
        allow(File).to receive(:foreach).with("#{TOPDIR}/fixtures/repo/Policyfile.rb").and_yield("# Policy\n").and_yield("name 'my_policy' # comment\n")
      end

      it 'returns the policy name' do
        expect(described_class.policy_name(node)).to eql 'my_policy'
      end
    end

    context "when a policyfile doesn't exist" do
      before do
        default_to_real_file_exists_method
        pretend_file_is_absent("#{TOPDIR}/fixtures/repo/Policyfile.rb")
      end

      it 'returns nil' do
        expect(described_class.policy_name(node)).to be_nil
      end
    end
  end
end

module PolicyfileDeliveryTruck
  module Helpers
    module_function

    # Returns the filename relative to the repo root
    def repo_path(node, filename)
      File.join(node['delivery']['workspace']['repo'], filename)
    end

    # Return whether there is a policyfile present in the repo
    def repo_has_policyfile?(node)
      File.exist?(repo_path(node, 'Policyfile.rb'))
    end

    def policy_changed?(node, _chef_server_url)
      # Work out if the policy we have in the repo is different than the
      # policy used to build the AMI
      return unless repo_has_policyfile?(node)
      chef_server = DeliverySugar::ChefServer.new
      chef_server.with_server_config do
        build_policy = Chef::ServerAPI.new.get('policy_groups')['build']['policies'][policy_name(node)]
        return true if build_policy.nil?
        return build_policy['revision_id'] != policy_revision(node)
      end
    end

    def policy_group(node)
      curr_stage = node['delivery']['change']['stage']
      delivery_config = node['delivery']['config']['policyfile-delivery-truck']
      # Return the current policy group
      if curr_stage != 'delivered'
        curr_stage
      else
        delivery_config['delivered_policy_group']
      end
    end

    # Return the policy name in the policyfile, if any
    def policy_name(node)
      return unless repo_has_policyfile?(node)
      policy = nil
      File.foreach(repo_path(node, 'Policyfile.rb')) do |l|
        m = /^\s*name ['"]([a-zA-Z0-9_-]+)["']/.match(l)
        if m
          policy = m[1]
          break
        end
      end
      policy
    end

    def policy_revision(node)
      return unless repo_has_policyfile?(node)
      policy = JSON.parse(File.read(repo_path(node, 'Policyfile.lock.json')))
      policy['revision_id']
    end
  end

  module DSL
    # methods that are included directly in the DSL where you have access to
    # things like the chef node. Things are split out like this to assist with
    # testing.
    def repo_path(filename)
      PolicyfileDeliveryTruck::Helpers.repo_path(node, filename)
    end

    def repo_has_policyfile?
      PolicyfileDeliveryTruck::Helpers.repo_has_policyfile?(node)
    end

    def policy_changed?
      PolicyfileDeliveryTruck::Helpers.policy_changed?(node, _chef_server_url)
    end

    def policy_group
      PolicyfileDeliveryTruck::Helpers.policy_group(node)
    end

    def policy_name
      PolicyfileDeliveryTruck::Helpers.policy_name(node)
    end

    def policy_revision
      PolicyfileDeliveryTruck::Helpers.policy_revision(node)
    end

    def chef_server_url
      begin
        delivery_config = node['delivery']['config']['policyfile-delivery-truck']
      rescue NoMethodError
        delivery_config = {}
      end
      url = delivery_config['chef-server']
      # Allow an empty value or a value of 'delivery' to signal that the
      # delivery chef server should be used.
      if url.empty? || url == 'delivery'
        delivery_chef_server[:chef_server_url]
      else
        url
      end
    end
  end
end

# And these mix the DSL methods into the Chef infrastructure
Chef::Recipe.send(:include, PolicyfileDeliveryTruck::DSL)
Chef::Resource.send(:include, PolicyfileDeliveryTruck::DSL)
Chef::Provider.send(:include, PolicyfileDeliveryTruck::DSL)

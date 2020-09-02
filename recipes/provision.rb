#
# Cookbook:: policyfile-delivery-truck
# Recipe:: provision
#
# Copyright:: 2016-2018, Chef Software Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

ruby_block 'copy policyfile from prior to current' do
  block do
    stage_list = %w(build acceptance union rehearsal delivered)
    curr_stage = node['delivery']['change']['stage']
    prev_stage = stage_list[stage_list.find_index(curr_stage) - 1]

    Chef::Log.info("Migrating policy from: #{prev_stage} to #{policy_group}")
    Chef::Log.info("Policy name: #{policy_name}")
    Chef::Log.info("Chef server URL: #{chef_server_url}")

    with_server_config do
      api = Chef::ServerAPI.new(chef_server_url)

      policy = api.get("/policy_groups/#{prev_stage}/policies/#{policy_name}")
      api.put("/policy_groups/#{policy_group}/policies/#{policy_name}", policy)
    end
  end

  only_if { repo_has_policyfile? }
end

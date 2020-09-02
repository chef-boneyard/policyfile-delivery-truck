#
# Cookbook:: policyfile-delivery-truck
# Recipe:: deploy
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

return unless node['delivery']['config']['delivery-truck']['deploy']['policyfile_push_jobs']

search_query = "policy_group:#{policy_group} AND policy_name:#{policy_name}"

my_nodes = delivery_chef_server_search(:node, search_query)
my_nodes.map!(&:name)

log "Search criteria used to deploy: #{search_query}"
log "Nodes to deploy: #{my_nodes}"

delivery_push_job "deploy_#{node['delivery']['change']['project']}" do
  command 'chef-client'
  nodes my_nodes
end

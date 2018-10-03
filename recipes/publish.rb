#
# Cookbook Name:: policyfile-delivery-truck
# Recipe:: publish
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

include_recipe 'delivery-truck::publish'

# Publish the policyfile
execute 'publish_policyfile_chef_install' do
  command "chef install --config #{delivery_knife_rb}"
  cwd node['delivery']['workspace']['repo']
  only_if { repo_has_policyfile? }
end

execute 'publish_policyfile_chef_push_to_build' do
  command "chef push build --config #{delivery_knife_rb}"
  cwd node['delivery']['workspace']['repo']
  only_if { repo_has_policyfile? && policy_changed? }
end

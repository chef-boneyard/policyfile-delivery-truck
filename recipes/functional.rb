#
# Cookbook:: policyfile-delivery-truck
# Recipe:: functional
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

execute 'functional_inspec' do
  command 'inspec exec default_spec.rb'
  cwd repo_path('inspec')
  environment('STAGE' => change.stage)
  only_if { ::File.exist?(repo_path('inspec/default_spec.rb')) }
end

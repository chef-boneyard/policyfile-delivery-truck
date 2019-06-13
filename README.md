**Umbrella Project**: [Automate](https://github.com/chef/chef-oss-practices/blob/master/projects/chef-automate.md)

**Project State**: [Deprecated](https://github.com/chef/chef-oss-practices/blob/master/repo-management/repo-states.md#deprecated)

**Issues [Response Time Maximum](https://github.com/chef/chef-oss-practices/blob/master/repo-management/repo-states.md)**: None

**Pull Request [Response Time Maximum](https://github.com/chef/chef-oss-practices/blob/master/repo-management/repo-states.md)**: None

# policyfile-delivery-truck

This is a Chef Delivery Build Cookbook for publishing Policyfiles with dependent cookbooks to a configured Chef Server.

## Project structure

In your own project, you need to have the following:

* Policyfile.rb - the policyfile for the application/deployment managed by Chef
* Policyfile.lock.json - the lockfile for the policy must be commited to the repository

If the lockfile is not commited to the repository, then doing a `chef install` has the potential to result in an unknown set of changes get pushed to acceptance.

## License and Author

- Joshua Timberman
- Josh Brand
- Mark Harrison

```text
Copyright:: 2016-2018 Chef Software, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

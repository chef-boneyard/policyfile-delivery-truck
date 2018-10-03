delivery_config = default['delivery']['config']['policyfile-delivery-truck']
delivery_truck_config = default['delivery']['config']['delivery-truck']

# These values can be overridden in config.json
# {
#   ...
#   "policyfile-delivery-truck": {
#     "chef-server": "foo",
#     "aws-creds": "bar"
#   }
# }

# The URL for the chef server to use
# delivery_config['chef-server'] = 'https://chef.example.com/organizations/orgname'

# Policy group name
# Change this to delivered-canary if you want to do canary deploys instead.
delivery_config['delivered_policy_group'] = 'delivered'
delivery_truck_config['deploy']['policyfile_push_jobs'] = false

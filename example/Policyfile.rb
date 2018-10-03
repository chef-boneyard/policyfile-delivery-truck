name 'example'

default_source :supermarket

run_list 'build-essential', 'packages', 'ntp', 'sudo'

default['authorization']['sudo']['passwordless'] = true
default['authorization']['sudo']['users'] = ['ubuntu']

default['packages-cookbook'] = ['git']

# Something we can change when we want to modify the policyfile
default['example']['some_number'] = 2

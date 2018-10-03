name 'example'

default_source :supermarket

run_list 'apt', 'build-essential', 'packages', 'ntp', 'users::sysadmins', 'sudo'

default['authorization']['sudo']['passwordless'] = true
default['authorization']['sudo']['users'] = ['ubuntu']

# Something we can change when we want to modify the policyfile
default['example']['some_number'] = 2

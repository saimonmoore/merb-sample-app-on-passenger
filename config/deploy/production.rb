set :domain, 'hello_merb.com'
set :remote_host_name, 'merbie'
set :branch, "production"
set :deploy_via, :remote_cache
set :repository_cache, "#{application}-src"
# ssh_options[:port] = 4567
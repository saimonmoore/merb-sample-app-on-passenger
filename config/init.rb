# Go to http://wiki.merbivore.com/pages/init-rb
 
require 'config/dependencies.rb'
 
Merb.push_path(:lib, Merb.root / "lib")

use_orm :datamapper
use_test :rspec
use_template_engine :haml
 
Merb::Config.use do |c|
  c[:use_mutex] = false
  c[:session_store] = 'cookie'  # can also be 'memory', 'memcache', 'container', 'datamapper
  
  # cookie session store configuration
  c[:session_secret_key]  = '9e1a711d805e1c37e98bd08c8c079630f7b13644'  # required for cookie session store
  c[:session_id_key] = '_hello_merb_session_id' # cookie session id key, defaults to "_session_id"
  c[:rpx_api_key] = '5ab432e30e471d774183d72edc91a693939bc43e'
  c[:rpx_token_param] = 'token'
end
 
Merb::BootLoader.before_app_loads do
  # This will get executed after dependencies have been loaded but before your app's classes have loaded.
end
 
Merb::BootLoader.after_app_loads do
  # This will get executed after your app's classes have been loaded.
end

set :stages, %w(staging production)
set :default_stage, 'staging'

require 'capistrano/ext/multistage'

set :application, "hello_merb"
set :domain, 'hello_merb.local'
set :repository, "git://github.com/saimonmoore/merb-sample-app-on-passenger.git"
set :deploy_to, "/opt/www/apps/#{application}"
 
set :scm, :git
set :git_shallow_clone, 1

set :keep_releases, 3
set :spinner_user, nil
set :runner, 'root'
# set :use_sudo, false
 
# comment out if it gives you trouble. newest net/ssh needs this set.
ssh_options[:paranoid] = false

role :app, domain
role :web, domain
role :db,  domain, :primary => true
 
#
# ==== Merb variables
#
 
set :merb_env, ENV["MERB_ENV"]

after "deploy:finalize_update", "symlink:database_yml"
 
namespace :symlink do
  desc "symlinks database.yml"
  task :database_yml, :roles => :app do
    run "ln -s #{shared_path}/database.server.yml #{latest_release}/config/database.yml"
  end
end
 
after "deploy:update_code", "deploy:native_gems"
 
namespace :deploy do
  
  # replace above task by the following (not namespaced) if you are using DM
  task :migrate, :roles => :db, :only => { :primary => true } do
    run "cd #{latest_release}; rake MERB_ENV=#{merb_env} #{migrate_env} dm:db:migrate"
  end
  
  desc "recompile native gems"
  task :native_gems do
    run "cd #{latest_release};bin/thor merb:gems:redeploy"
  end

  desc "Restart Application"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  desc "Restart apache"
  task :restart_apache, :roles => :web do
    sudo "apachectl graceful"
  end
  
end

require 'rubygems'
require 'rack'
require 'merb-core'

Gem.clear_paths

$BUNDLE = true
gems_dir = File.expand_path(File.join(File.dirname(__FILE__),'gems'))
Gem.path.unshift(gems_dir)

Merb::Config.setup(:merb_root => File.expand_path(File.dirname(__FILE__)),
                   :environment => ENV['RACK_ENV'])
Merb.environment = Merb::Config[:environment]
Merb.root = Merb::Config[:merb_root]

use Rack::CommonLogger

map '/' do
  Merb::BootLoader.run
  run Merb::Rack::Application.new
end

map '/version' do
  map '/' do
    run Proc.new {|env| [200, {"Content-Type" => "text/html"}, "infinity 0.1"] }
  end
  
  map '/env' do
    infinity = Proc.new {|env| [200, {"Content-Type" => "text/html"}, env.inspect]}
    run infinity
  end
end
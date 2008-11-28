# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ebb}
  s.version = "0.3.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["ry dahl"]
  s.date = %q{2008-08-20}
  s.description = %q{}
  s.email = %q{ry at tiny clouds dot org}
  s.extensions = ["ext/extconf.rb"]
  s.files = ["libev/ev_epoll.c", "libev/ev_select.c", "libev/ev_poll.c", "libev/ev.c", "libev/event.c", "libev/ev_port.c", "libev/ev_kqueue.c", "libev/ev_win32.c", "libev/ev++.h", "libev/event.h", "libev/ev.h", "libev/ev_wrap.h", "libev/ev_vars.h", "lib/ebb/version.rb", "lib/ebb.rb", "ext/extconf.rb", "ext/ebb_request_parser.rl", "ext/rbtree.c", "ext/ebb.c", "ext/ebb_ffi.c", "ext/ebb_request_parser.c", "ext/ebb_request_parser.h", "ext/ebb.h", "ext/rbtree.h", "README", "Rakefile"]
  s.homepage = %q{http://ebb.rubyforge.org}
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.4")
  s.rubyforge_project = %q{ebb}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A Web Server}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

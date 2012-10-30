$:.push File.expand_path("../lib",__FILE__)
require 'rest/version'

Gem::Specification.new do |s|
	s.name       = "rest-terminal"
	s.version    = Rest::Version
	s.author     = ["WHarsojo"]
	s.email      = ["wharsojo@gmail.com"]
	s.homepage   = "http://github.com/wharsojo"
	s.summary    = %q{Rest API Test on Terminal}

	s.rubyforge_project = "rest-terminal"

	s.files      = %w[bin/rest bin/rt lib/rest.rb lib/service_base.rb lib/rest/terminal.rb lib/rest/terminal/commands.rb lib/rest/terminal/commands_info.rb lib/rest/terminal/persistent.rb lib/rest/terminal/persistent_rc.rb lib/rest/service.rb lib/rest/version.rb] 

	s.test_files = []

	s.require_paths = ["lib"] 
    s.executables   = ["rest","rt"]
	s.add_runtime_dependency "json", '~>1.7.5'
	s.add_runtime_dependency "term-ansicolor", '~>1.0.7'
	s.add_runtime_dependency "faraday", '~>0.8.4'
	s.post_install_message = ">>In your console, type 'rest' or 'rt' to run this program<<"
end

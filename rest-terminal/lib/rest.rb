#!/usr/bin/env ruby
require 'json'
require 'term/ansicolor'
include Term::ANSIColor

class Hash
  def pj
    JSON.pretty_generate(self)
  end
end

class String
  def pj
    JSON.pretty_generate(JSON.parse(self))
  end
end

require 'service_base'
require 'rest/version'
require 'rest/terminal/commands'
require 'rest/terminal/commands_info'
require 'rest/terminal/persistent'
# require 'rest/terminal/persistent_rc'
require 'rest/terminal'

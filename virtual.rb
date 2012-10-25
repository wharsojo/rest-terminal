require 'json'
require 'term/ansicolor'
include Term::ANSIColor

class String
  include Term::ANSIColor

  def pj
    JSON.pretty_generate(JSON.parse(self))
  end

  def space_color
  	c="#{self} ".split(/\//)
    c[-1].strip!
  	"#{c.collect{|x|x.intense_red}.join('/'.red)}"
  end

  def command_color
    if self.length > 0
      l = self[/^ *\w+ */]
      c = "#{self[l.length,99]} ".split(/\//)
      c[-1].strip!
      "#{l.green}#{c.collect{|x|x.intense_red}.join('/'.red)}"
    else
      self
    end
  end
end

require './space/space_base.rb'
require './space/stripe.rb'
require './space/twitter.rb'
require './v_console/persistent.rb'
require './v_console/commands.rb'
require './v_console/get_c.rb'
require './v_console.rb'

Console = VConsole.new
require './earth_rc.rb'
Console.run 

require 'term/ansicolor'
include Term::ANSIColor

class String
  include Term::ANSIColor

  def space_color
  	x=self.split('/').collect{|x|x.intense_red}.join('/'.red)
  	"#{x}#{'/'.red}"
  end

  def command_color
    l = self[/^ *\w+ */]
    c = "#{l.green}#{self[l.length,99]} ".split(/\//).
    collect{|x|x.intense_red}
    c[-1] = ''
    c.join('/'.red)
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

require 'term/ansicolor'
include Term::ANSIColor

class String
  include Term::ANSIColor
  def space_color
  	x=self.split('/').collect{|x|x.intense_red}.join('/'.red)
  	"#{x}#{'/'.red}"
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

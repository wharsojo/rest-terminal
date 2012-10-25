class VConsole
  include Commands
  include Persistent

  def initialize
    @skey = ''
    @repl = ''
    @type = 'earth'
    @serv = 'localhost'
  end

  def run
    is_cmd = true
    @hist = @@history.length
    until @repl == 'exit'
      print "#{prompt} " if is_cmd
      @repl,@skey = GetC.get(@repl) # @repl = gets.chomp
      is_cmd = /\n|\r/ =~ @skey
      if !(is_cmd)
        navkey 
      elsif @repl != 'exit'
        parse  
      end
    end
  end

  private
  def navkey
    print "#{GetC::C_Erase_line}#{prompt}"
    if @skey == GetC::CUp
      @hist -= 1 if @hist > 0
      @repl = @@history[@hist].to_s.command_color
      print @repl
    elsif @skey == GetC::CDown
      @hist += 1 if @hist < @@history.length
      @repl = @@history[@hist].to_s.command_color
      print @repl
    end
  end

  def parse
    print "\n"
    @repl.strip!
    if @repl==''
      @repl='exit'
    else
      # found = cmd[0]=="_"
      @_status = ''
      cmd = @repl.split(/ +/)[0].to_s
      if Commands.instance_methods.index("_#{cmd}".to_sym) 
        exec(cmd) 
        puts "> #{@_status}".intense_magenta 
      else
        puts "Commands not found >>#{@repl}<<".red
      end
      @repl = ''
    end
  end

  def exec(c)
    @@history << @repl
    @@history = @@history.reverse.uniq.reverse
    @hist = @@history.length
    @repl = @repl.gsub(/^#{c}/,'').strip
    self.send("_#{c}") #if self.respond_to?("_#{c}")
  end

  def prompt
    "#{@type}@#{@serv} >".yellow
  end
end


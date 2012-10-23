require 'io/console'

class VConsole
  include Commands
  include Persistent

  def initialize
    @keys = ''
    @repl = ''
    @type = 'earth'
    @serv = 'localhost'
  end

  def run
    until @repl == 'exit'
      @_status = ''
      print "#{prompt} "
      @repl = getr # @repl = gets.chomp
      parse if @repl != 'exit'
      puts "> #{@_status}".intense_magenta 
    end
  end

  private

  def c_up
    "\e[A"
  end

  def c_down
    "\e[B"
  end

  def c_right
    "\e[C"
  end

  def c_left
    "\e[D"
  end

  def c_bspc
    "\x7F"
  end

  def a_beol
    "\033[1D\033[K"
  end

  def a_clear
    "\033[2J"
  end

  def parse
    @repl.strip!
    cmd   = @repl.split(/ +/)[0]
    @_tmp = Commands.instance_methods
    found = @_tmp.index("_#{cmd[0]}".to_sym)
    found = @_tmp.index("_#{cmd}".to_sym) if !found
    exec(cmd) if found
  end

  def exec(c)
    @@history << @repl
    @repl = @repl.gsub(/^#{c}/,'').strip
    self.send("_#{c}") #if self.respond_to?("_#{c}")
  end

  def prompt
    "#{@type}@#{@serv} >".yellow
  end

  def getr
    chr = ""
    row = ""
    @keys = ''
    until  /\n|\r/ =~ chr || chr == "\x03"  || 
      chr == c_up    || chr == c_down ||
      chr == c_right || chr == c_left
      if chr == c_bspc 
        if row.length>0
          row = row[0,row.length-1]
          print a_beol
        end
      else
        row = "#{row}#{chr}"
        if /[a-zA-Z0-9_\-\/=*. ]/ =~ chr
          if chr=='/'
            print chr.red 
          elsif row.strip.split(/ +/).length>1
            print chr.intense_red
          else
            print chr.green
          end
        end
      end

      begin
        system("stty raw -echo")
        chr = STDIN.getc.chr

        if(chr=="\e")
          extra_thread = Thread.new{
            chr = chr + STDIN.getc.chr
            chr = chr + STDIN.getc.chr
          }
          # wait just long enough for special keys to get swallowed
          extra_thread.join(0.00001)
          # kill thread so not-so-long special keys don't wait on getc
          extra_thread.kill
          @keys = chr
          # p chr
        end
      ensure
        system("stty -raw echo")
      end
    end
    print "\n" if @keys==''
    row
  end

end


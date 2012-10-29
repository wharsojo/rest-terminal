module Rest
  class Terminal
    module PersistentRc
    end
    
    class << self
      include Persistent
      include PersistentRc
      include Commands

      def initialize
        @skey     = ''
        @repl     = ''
        @type     = 'earth'
        @serv     = 'localhost'
        @services = { }
        @response = { }
        @spaces   = [ ]
        @hist     = [ ]
        @prm      = [ ]
        @pwd      = '/'
        @cmd      = ''
        @_status  = ''
      end

      def run
        initialize
        if is_cmd_in_commands?
          #p "WWWWWW #{@cmd} #{__FILE__} #{Dir.pwd}"
          if @cmd == "init" || is_runable?
            load_state
            execute
            save_vars
          end
        else
          invalid_command
        end
      end

      def load_state
        if File.exists?('./.rest-terminal/persistent_rc.rb')
          require './.rest-terminal/persistent_rc'
          load_vars
          load_services
        end
      end

      def is_cmd_in_commands?
        puts ARGV.inspect.red
        @cmd = ARGV[0].to_s
        parm = ARGV[1,99]
        @prm = parm ? parm : [ ] #.join(' ') : ''
        commands.index(@cmd) ? @cmd : nil
        # if singleton_class.private_instance_methods(false).index(@@cmd.to_sym) 
      end

      def invalid_command
        puts "#{('='*65)}\n#{'invalid command!'.red}\n#{('-'*65).yellow}"
        puts "valid commands are:\n#{commands.sort.collect{|x|x.green}.join(', ')}"
      end

      def commands
        Rest::Terminal::Commands.private_instance_methods.collect do |x|
          "#{x[1,99]}"
        end
      end

      def execute
        puts "="*65
        send("_#{@cmd}")
        puts @_status.green
        save_hist
      end

      def prompt
        "#{@type}@#{@serv} >".yellow
      end

      def current_path
        "services#{@pwd}"
      end

      def space_path(spc)
        (spc[0] == '/')  ? spc : "#{@pwd}#{spc}"
      end

      def full_path(spc)
        x = "#{@pwd} "
        l = x.count('/')+1
        dots = spc[/\.+/]
        if dots && 
          set = l-dots.length
          set = 1 if set < 1
          path_up = x.split(/\//)[0,set].join('/')
          spc = spc.gsub(/\.+/,path_up)
        end
        spc = "#{spc}/" if spc[-1]!='/'
        space_path(spc)
      end

      def multi_exec(cmd)
        @prm = ['.'] if @prm==[]
        @prm.each do |prm|
          prm = @pwd if prm=='.'
          pth = full_path(prm)
          puts "Service: #{pth}".yellow
          @_status = @services[pth].send(cmd,prm)
        end
      end

		end
	end
end


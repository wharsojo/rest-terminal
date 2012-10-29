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

require './service_base'

module Rest
	class Terminal

    module Persistent
      private 
      def load_services
        paths = "#{@pwd.strip} ".split(/\//).collect(&:strip).reject(&:empty?).unshift('')
        p2 = ''
        paths.each do |path|
          p1 = p2
          p2 = "#{p2}#{path}/"
          pr = @services[p1]
          @services[p2] = ServiceBase.new(pr,p2)
          # p "PARRENT: #{pr} - #{p1} - #{p2}"
          # p @services[p2].vars
        end
        pr = @services[@pwd]
        path = Dir["#{current_path}*/"]
        path.collect do |px|
          p2 = px[/\/.*/]
          @services[p2] = ServiceBase.new(pr,p2)
        end
      end

      def save_hist
        @hist<<@cmd
        @hist = @hist.reverse.uniq.reverse
      end

      def save_vars
        # p "pwd before save: #{@pwd}"
        b = ['']
        b << "@pwd  = #{@pwd.inspect}"
        b << "@serv = #{@serv.inspect}"
        b << "@hist = #{@hist.inspect}"
        b << "@response = #{@response.inspect}"
        c = b.join("\n        ")
        s = "#env_start(.*)#env_end" 
        code = IO.read('./.rest-terminal/rest_rc.rb')
        #-----------------------------------------
        x = code.split(/#{s}/m)
        x[1] = "#env_start#{c}\n        #env_end"
        #-----------------------------------------
        IO.write('./.rest-terminal/rest_rc.rb', x.join)
      end
    end 

    module Commands
      def is_runable?
        is_restt = File.directory?(".rest-terminal")
        if !is_restt
          puts "\nPlease run command \"init\" to start REST Terminal!".red
          puts "\n"
        end
        is_restt
      end

      private

      def _add
        @prm.each do |prm|
          fp = full_path(prm)
          if File.directory?("services#{fp}")
            fp = "Service already exists! #{fp}".red
          else
            FileUtils.mkdir_p("services#{fp}")
            `cp ./service.rb services#{fp}`
          end
        end
        @_status = "#{@prm.length} service created!"
      end

      def _cd
        fp = full_path(@prm[0])
        if File.directory?("services#{fp}")
          @pwd = fp
        else
          fp = "Service not exists! #{fp}".red
        end
        @_status = fp
      end

      def _history
        @hist.each_with_index do |itm,idx| 
          puts "#{idx.to_s.rjust(2,'0')} > `#{itm}`"
        end
        @_status = "#{@hist.length} histories"
      end

      def _ls
        path = Dir["#{current_path}*/"]
        path.collect do |x|
          puts x.sub(current_path,'/')
        end
        @_status = "#{path.length} services"
        # p "lolllll >>#{@serv}<< ."
      end

      def _pwd
        @_status = "\"#{@pwd}\""
      end

      def _info
        multi_exec(:_info)
        @_status = ""
        # @_status = @services[@pwd]._info(@prm)
      end

      def _response
        @_status = @services[@pwd]._response(@prm)
      end

      def _headers
        @_status = @services[@pwd]._headers(@prm)
      end

      def _body
        @_status = @services[@pwd]._body(@prm)
      end

      def _vars
        if @prm.length>1 && !@prm[/\=/]
          pth = @prm.shift
          @_status = @services[pth]._vars(@prm)
        else
          @_status = @services[@pwd]._vars(@prm)
        end
      end

      def _reset
        @_status = @services[@pwd]._reset(@prm)
      end

      def _send
        multi_exec(:_send)
        @_status = ""
      end

    end


		class << self
      include Persistent
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

      def init
        require 'fileutils'
        # `mkdir -p .rest-terminal`
        FileUtils.mkdir_p ".rest-terminal"
        `cp ./rest_rc.rb .rest-terminal`
        require './.rest-terminal/rest_rc'
        load_vars
        FileUtils.mkdir_p "services"
        `cp ./service.rb services`
        @spaces.each do |path|
          # `mkdir -p services#{path}`
          FileUtils.mkdir_p "services#{path}"
          `cp ./service.rb services#{path}`
        end
        @hist   = ['init']
        @pwd    = '/'
        @_status = 'OK'
      end

      def run
        initialize
        if is_cmd_in_commands?
          if @cmd == :init || is_runable?
            load_state
            execute
            save_vars
          end
        else
          invalid_command
        end
      end

      def load_state
        if File.exists?('./.rest-terminal/rest_rc.rb')
          require './.rest-terminal/rest_rc'
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
        puts "\ninvalid command!\n".red
        puts "valid commands are: "
        puts "#{commands}"
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

Rest::Terminal.run
# body amount=400 currency=usd "description=Charge for test@example.com" card=tok_0bEC1DZtDZTK69
# ➜ ./rest set dod = "{ wow : canggih, \
#                        longont: sayut }"
# ["set", "dod", "=", "{ wow : canggih, longont: sayut }"]
module Rest
  class Terminal
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

      def _init
        require 'fileutils'
        pth = File.dirname(__FILE__)
        FileUtils.mkdir_p ".rest-terminal"
        `cp #{pth}/terminal/persistent_rc.rb .rest-terminal`
        require './.rest-terminal/persistent_rc'
        load_vars
        FileUtils.mkdir_p "services"
        `cp #{pth}/service.rb services`
        @spaces.each do |path|
          # `mkdir -p services#{path}`
          FileUtils.mkdir_p "services#{path}"
          #`cp ./service.rb services#{path}`
          `cp #{pth}/service.rb services#{path}`
        end
        @hist   = ['init']
        @pwd    = '/'
        @_status = 'OK'
      end

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
  end
end

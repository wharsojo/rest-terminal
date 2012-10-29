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
          p "PARRENT: #{pr} - #{p1} - #{p2}"
          p @services[p2].vars
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
        code = IO.read('./.rest-terminal/persistent_rc.rb')
        #-----------------------------------------
        x = code.split(/#{s}/m)
        x[1] = "#env_start#{c}\n        #env_end"
        #-----------------------------------------
        IO.write('./.rest-terminal/persistent_rc.rb', x.join)
      end
    end 
  end
end
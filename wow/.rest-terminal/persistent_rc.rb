module Rest
  class Terminal
    module PersistentRc
      private 
      def load_vars
        spaces = []
        #space_start
        spaces << '/mdk/merchant_detail/'
        spaces << '/mdk/merchant_new/'
        spaces << '/stripe/charges/'
        spaces << '/stripe/token/'
        spaces << '/twitter/b/c/d/'
        #space_end
        # ::Rest::Terminal.instance_variable_set("@serv",spaces)
        @spaces = spaces
        # spaces.each do |row|
          # @repl = row ; _add(true)
        # end
        # @repl = ''

        #env_start
        @pwd  = "/stripe/"
        @serv = "localhost"
        @hist = ["init", "cd", "info", "ls"]
        @response = {}
        #env_end
      end
    end
  end
end
module Rest
  class Terminal
    module PersistentRc
      private 
      def load_vars
        spaces = []
        #space_start
        spaces << '/google/search/'
        #space_end
        # ::Rest::Terminal.instance_variable_set("@serv",spaces)
        @spaces = spaces
        # spaces.each do |row|
          # @repl = row ; _add(true)
        # end
        # @repl = ''

        #env_start
        @hist = [ ]
        @pwd  = "/google/"
        @serv = "localhost"
        #env_end
      end
    end
  end
end
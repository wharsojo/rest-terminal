module Rest
	class Terminal

    module Persistent
      private 
      def load_vars
        spaces = []
        #space_start
        spaces << '/a/b/c/d/'
        spaces << '/b/rest/create/'
        spaces << '/b/rest/update/'
        spaces << '/c/a/b/c/d/'
        spaces << '/c/b/'
        spaces << '/c/d/e/'
        spaces << '/mdk/merchant_detail/'
        spaces << '/mdk/merchant_new/'
        spaces << '/rest/'
        spaces << '/stripe/charges/'
        spaces << '/stripe/token/'
        spaces << '/twitter/b/c/d/'
        #space_end
        # ::Rest::Terminal.instance_variable_set("@serv",spaces)
        # @spaces = spaces
        # spaces.each do |row|
          # @repl = row ; _add(true)
        # end
        # @repl = ''

        #env_start
        @hist = [:ls, :pwd, :init]
        @pwd  = "/b/rest/"
        @serv = "localhost"
        #env_end
      end
    end
  end
end
module Rest
	class Terminal

    module Persistent
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
        @hist = [:cd, :reset, :pwd, :ls, :vars, :headers, "headers", "response", "history", "vars", "info", "cd", "pwd", "send", "body", "ls"]
        @response = {:status=>200, :headers=>{"server"=>"nginx", "date"=>"Sun, 28 Oct 2012 22:02:17 GMT", "content-type"=>"application/json;charset=utf-8", "content-length"=>"600", "connection"=>"close", "access-control-allow-credentials"=>"true", "cache-control"=>"no-cache, no-store", "access-control-max-age"=>"300"}, :body=>{"amount"=>0, "created"=>1351461737, "currency"=>"usd", "id"=>"tok_0dKnOpChiSe6Sp", "livemode"=>false, "object"=>"token", "used"=>false, "card"=>{"address_city"=>nil, "address_country"=>nil, "address_line1"=>nil, "address_line1_check"=>nil, "address_line2"=>nil, "address_state"=>nil, "address_zip"=>nil, "address_zip_check"=>nil, "country"=>"US", "cvc_check"=>nil, "exp_month"=>5, "exp_year"=>2013, "fingerprint"=>"PvKkd17TxyqPEYGt", "last4"=>"4242", "name"=>nil, "object"=>"card", "type"=>"Visa"}}}
        #env_end
      end
    end
  end
end
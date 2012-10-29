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
        @hist = [:ls, :pwd, :init, "pwd", "cd", "ls", "body", "info", "send"]
        @response = {:status=>200, :headers=>{"server"=>"nginx", "date"=>"Mon, 29 Oct 2012 08:53:35 GMT", "content-type"=>"application/json;charset=utf-8", "content-length"=>"600", "connection"=>"close", "access-control-allow-credentials"=>"true", "cache-control"=>"no-cache, no-store", "access-control-max-age"=>"300"}, :body=>{"amount"=>0, "created"=>1351500815, "currency"=>"usd", "id"=>"tok_0dVJaOA5AOt8Yk", "livemode"=>false, "object"=>"token", "used"=>false, "card"=>{"address_city"=>nil, "address_country"=>nil, "address_line1"=>nil, "address_line1_check"=>nil, "address_line2"=>nil, "address_state"=>nil, "address_zip"=>nil, "address_zip_check"=>nil, "country"=>"US", "cvc_check"=>nil, "exp_month"=>5, "exp_year"=>2013, "fingerprint"=>"PvKkd17TxyqPEYGt", "last4"=>"4242", "name"=>nil, "object"=>"card", "type"=>"Visa"}}}
        #env_end
      end
    end
  end
end
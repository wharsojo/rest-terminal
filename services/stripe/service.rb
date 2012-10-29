response = {}
headers = {}
bodies = {}
vars = {}
#vars_start
response = {:status=>200, :headers=>{"server"=>"nginx", "date"=>"Mon, 29 Oct 2012 08:53:35 GMT", "content-type"=>"application/json;charset=utf-8", "content-length"=>"600", "connection"=>"close", "access-control-allow-credentials"=>"true", "cache-control"=>"no-cache, no-store", "access-control-max-age"=>"300"}, :body=>{"amount"=>0, "created"=>1351500815, "currency"=>"usd", "id"=>"tok_0dVJaOA5AOt8Yk", "livemode"=>false, "object"=>"token", "used"=>false, "card"=>{"address_city"=>nil, "address_country"=>nil, "address_line1"=>nil, "address_line1_check"=>nil, "address_line2"=>nil, "address_state"=>nil, "address_zip"=>nil, "address_zip_check"=>nil, "country"=>"US", "cvc_check"=>nil, "exp_month"=>5, "exp_year"=>2013, "fingerprint"=>"PvKkd17TxyqPEYGt", "last4"=>"4242", "name"=>nil, "object"=>"card", "type"=>"Visa"}}}
headers  = {:"content-type"=>"application/x-www-form-urlencoded", :authorization=>"Basic YzNqdDdmRzYzZ1JkdTVweEJuWXkxMmZUT0RQVkRuQXE6\\n"}
bodies   = {:"card[number]"=>"4242424242424242", :"card[exp_month]"=>"05", :"card[exp_year]"=>"2013", :"card[cvc]"=>"123", :charges=>nil}
vars     = {:url=>"https://api.stripe.com/v1/tokens", :conn=>"post"}
#vars_end
response.each { |k,v| @response[k] = v }
headers.each  { |k,v| @headers[k] = v }
bodies.each   { |k,v| @bodies[k] = v }
vars.each     { |k,v| @vars[k] = v }

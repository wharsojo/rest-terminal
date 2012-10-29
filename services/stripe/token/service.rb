response = {}
headers = {}
bodies = {}
vars = {}
#vars_start
response = {:status=>200, :headers=>{"server"=>"nginx", "date"=>"Sun, 28 Oct 2012 22:02:17 GMT", "content-type"=>"application/json;charset=utf-8", "content-length"=>"600", "connection"=>"close", "access-control-allow-credentials"=>"true", "cache-control"=>"no-cache, no-store", "access-control-max-age"=>"300"}, :body=>{"amount"=>0, "created"=>1351461737, "currency"=>"usd", "id"=>"tok_0dKnOpChiSe6Sp", "livemode"=>false, "object"=>"token", "used"=>false, "card"=>{"address_city"=>nil, "address_country"=>nil, "address_line1"=>nil, "address_line1_check"=>nil, "address_line2"=>nil, "address_state"=>nil, "address_zip"=>nil, "address_zip_check"=>nil, "country"=>"US", "cvc_check"=>nil, "exp_month"=>5, "exp_year"=>2013, "fingerprint"=>"PvKkd17TxyqPEYGt", "last4"=>"4242", "name"=>nil, "object"=>"card", "type"=>"Visa"}}}
headers  = {}
bodies   = {}
vars     = {}
#vars_end
response.each { |k,v| @response[k] = v }
headers.each  { |k,v| @headers[k] = v }
bodies.each   { |k,v| @bodies[k] = v }
vars.each     { |k,v| @vars[k] = v }

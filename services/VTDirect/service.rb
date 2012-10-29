response = {}
headers = {}
bodies = {}
vars = {}
#vars_start
headers  = {:limit=>"10"}
vars = {:timeout=>15, :conn=>"get", :url=>"http://localhost:3000", :ddd=>"wwwww"}
#vars_end
response.each { |k,v| @response[k] = v }
headers.each  { |k,v| @headers[k] = v }
bodies.each   { |k,v| @bodies[k] = v }
vars.each     { |k,v| @vars[k] = v }

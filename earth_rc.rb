Console.instance_eval <<END
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
  spaces.each do |row|
    @repl = row ; _add(true)
  end
  @repl = ''
END

module VConsole::Commands # .class_eval <<END
  def self.load_persistent(vars,inst)
    vars.each do |k,v|
      tmp = @@spaces[k].instance_variable_get(inst)
      v.each do |x,y|
        tmp[x] = y
      end
    end
  end
 
  headers = {}
  #headers_start
  headers['/'] = {:CONTENT_TYPE=>"application/x-www-form-urlencoded"}
  headers['/mdk/'] = {:CONTENT_TYPE=>"application/json"}
  headers['/stripe/'] = {:CONTENT_TYPE=>"application/x-www-form-urlencoded", :Authorization=>"Basic YzNqdDdmRzYzZ1JkdTVweEJuWXkxMmZUT0RQVkRuQXE6\n"}
  headers['/twitter/'] = {:wow=>"kereen"}
  headers['/b/rest/'] = {:CONTENT_TYPE=>"application/json"}
  headers['/rest/'] = {:CONTENT_TYPE=>"application/json"}
  #headers_end  
  load_persistent(headers,'@headers')

  vars = {}
  #vars_start
  vars['/'] = {:timeout=>15, :conn=>"get", :url=>"http://localhost:3000"}
  vars['/b/'] = {:wow=>"kereeeen", :eee=>"ddddddd"}
  vars['/mdk/'] = {:url=>"http://10.2.250.12:8080/mdk/rest/merchant/new", :conn=>"post", :body=>"{\"id\":\"merchant id\",\"ccid\":\"merchant ccid\",\"hash\":\"merchant hash\"}"}
  vars['/mdk/merchant_detail/'] = {:timeout=>15, :conn=>"get", :url=>"http://localhost:3000", :wow=>"canggih"}
  vars['/mdk/merchant_new/'] = {:url=>"http://10.2.250.12:8080/mdk/rest/merchant/new", :body=>"{\"id\":\"merchant id\",\"ccid\":\"merchant ccid\",\"hash\":\"merchant hash\"}"}
  vars['/stripe/'] = {:timeout=>15, :url=>"https://api.stripe.com/v1/tokens", :body=>"card[number]=4242424242424242&card[exp_month]=05&card[exp_year]=2013&card[cvc]=123"}
  vars['/stripe/charges/'] = {:timeout=>15, :url=>"https://api.stripe.com/v1/charges", :body=>"amount=400&currency=usd&description=Charge for test@example.com&card=tok_0bEC1DZtDZTK69"}
  vars['/stripe/token/'] = {:timeout=>15, :url=>"https://api.stripe.com/v1/tokens", :body=>"amount=400&currency=usd&description=Charge for testexample.com&card=tok_jOq0M8vJprCUUU"}
  vars['/twitter/'] = {:go=>"language"}
  vars['/b/rest/'] = {:timeout=>15, :conn=>"get", :url=>"http://localhost:3000"}
  vars['/b/rest/create/'] = {:timeout=>15, :conn=>"get", :url=>"http://localhost:3000"}
  vars['/b/rest/update/'] = {:timeout=>15, :conn=>"get", :url=>"http://localhost:3000"}
  #vars_end
  load_persistent(vars,'@vars')
  
  #env_start
  @@history = ["rm /d", "rm /stripe/token/a/", "c", "create /a/b/c", "rm /a", "create a/b/c", "rm a/b/c", "rm a", "cd tw", "headers wow=kereen", "cp /c .", "cp /c/d .", "cp /c/d c", "cp /c/d c/d", "rm /twitter/c", "rm /twitter/d", "create mdk", "cd mdk", "create merchant/new", "set url=http//10.2.250.128080/mdk/rest/merchant/new", "set conn=post", "set url=http://10.2.250.12:8080/mdk/rest/merchant/new", "send /twitter/", "send /twitter/b", "rm merchant/new", "create merchant_new", "send", "reset", "cd ..", "create merchant_detail", "rm merchant/", "cd new", "set url = http://10.2.250.12:8080/mdk/rest/merchant/new", "set body={\"id\":\"merchant id\",\"ccid\":\"merchant ccid\",\"hash\":\"merchant hash\"}", "set body={}", "set body={\"id\":\"wow kereen\"}", "set", "set body = {\"id\":\"merchant id\",\"ccid\":\"merchant ccid\",\"hash\":\"merchant hash\"}", "help", "clear", "cp /b /c", "cp /a /c", "l", "cp / /a/b/c", "cd", "cd _new", "cd _det", "set wow = kereen", "vars", "headers", "h", "set wow=canggih", "save", "cd /b", "info", "cd /", "create rest", "cd rest", "ls", "create create", "create update"]
  @@pwd = "/b/rest/"
  #env_end

  # @@spaces['/']._set("go=lang")
  # @@spaces['/a'] = SpaceBase.new(@@spaces['/']) 
#END
end
Console.instance_eval <<END
  spaces = []
  #space_start
  spaces << '/b/'
  spaces << '/c/d/e/'
  spaces << '/mdk/merchant/'
  spaces << '/mdk/merchant_new/'
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
  headers['/mdk/merchant/'] = {:CONTENT_TYPE=>"application/json"}
  headers['/stripe/'] = {:CONTENT_TYPE=>"application/x-www-form-urlencoded", :Authorization=>"Basic YzNqdDdmRzYzZ1JkdTVweEJuWXkxMmZUT0RQVkRuQXE6\n"}
  headers['/twitter/'] = {:wow=>"kereen"}
  #headers_end  
  load_persistent(headers,'@headers')

  vars = {}
  #vars_start
  vars['/'] = {:timeout=>15, :conn=>"get", :url=>"http://localhost:3000"}
  vars['/b/'] = {:wow=>"kereeeen"}
  vars['/mdk/'] = {:url=>"http://10.2.250.12:8080/mdk/rest/merchant/new", :conn=>"post", :body=>"{\"id\":\"merchant id\",\"ccid\":\"merchant ccid\",\"hash\":\"merchant hash\"}"}
  vars['/stripe/'] = {:timeout=>15, :url=>"https://api.stripe.com/v1/tokens", :body=>"card[number]=4242424242424242&card[exp_month]=05&card[exp_year]=2013&card[cvc]=123"}
  vars['/stripe/charges/'] = {:timeout=>15, :url=>"https://api.stripe.com/v1/charges", :body=>"amount=400&currency=usd&description=Charge for test@example.com&card=tok_0bEC1DZtDZTK69"}
  vars['/stripe/token/'] = {:timeout=>15, :url=>"https://api.stripe.com/v1/tokens", :body=>"amount=400&currency=usd&description=Charge for testexample.com&card=tok_jOq0M8vJprCUUU"}
  vars['/twitter/'] = {:go=>"language"}
  #vars_end
  load_persistent(vars,'@vars')
  
  #env_start
  @@history = ["rm /d", "rm /stripe/token/a/", "help", "c", "create /a/b/c", "rm /a", "create a/b/c", "rm a/b/c", "rm a", "cd tw", "headers wow=kereen", "cp /c .", "cp /c/d .", "cp /c/d c", "cp /c/d c/d", "rm /twitter/c", "rm /twitter/d", "cd", "create mdk", "cd mdk", "create merchant/new", "set url=http//10.2.250.128080/mdk/rest/merchant/new", "set conn=post", "set url=http://10.2.250.12:8080/mdk/rest/merchant/new", "headers", "send /twitter/", "send /twitter/b", "l", "rm merchant/new", "create merchant_new", "clear", "ls", "h", "send", "cd _new", "reset", "info", "save"]
  @@pwd = "/mdk/merchant_new/"
  #env_end

  # @@spaces['/']._set("go=lang")
  # @@spaces['/a'] = SpaceBase.new(@@spaces['/']) 
#END
end
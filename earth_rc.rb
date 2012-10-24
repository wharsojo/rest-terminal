Console.instance_eval <<END
  spaces = []
  #space_start
  spaces << '/b/'
  spaces << '/c/d/e/'
  spaces << '/stripe/charges/'
  spaces << '/stripe/token/'
  spaces << '/twitter/b/c/d/'
  #space_end
  spaces.each do |row|
    @repl = row ; _add(true)
  end
  @repl = ''
END

VConsole::Commands.class_eval <<END
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
  headers['/'] = {:CONTENT_TYPE=>"application/x-www-form-urlencoded", :Authorization=>"Basic YzNqdDdmRzYzZ1JkdTVweEJuWXkxMmZUT0RQVkRuQXE6\n"}
  headers['/stripe/'] = {:CONTENT_TYPE=>"application/x-www-form-urlencoded", :Authorization=>"Basic YzNqdDdmRzYzZ1JkdTVweEJuWXkxMmZUT0RQVkRuQXE6\n"}
  headers['/twitter/'] = {:wow=>"kereen"}
  #headers_end  
  load_persistent(headers,'@headers')

  vars = {}
  #vars_start
  vars['/'] = {:timeout=>15, :url=>"http://localhost:3000"}
  vars['/b/'] = {:wow=>"kereeeen"}
  vars['/stripe/'] = {:timeout=>15, :url=>"https://api.stripe.com/v1/tokens", :body=>"card[number]=4242424242424242&card[exp_month]=05&card[exp_year]=2013&card[cvc]=123"}
  vars['/stripe/charges/'] = {:url=>"https://api.stripe.com/v1/charges", :body=>"amount=400&currency=usd&description=Charge for test@example.com&card=tok_0bEC1DZtDZTK69"}
  vars['/stripe/token/'] = {:body=>"amount=400&currency=usd&description=Charge for testexample.com&card=tok_jOq0M8vJprCUUU"}
  vars['/twitter/'] = {:go=>"language"}
  #vars_end
  load_persistent(vars,'@vars')
  
  #env_start
  @@history = ["rm /d", "rm /stripe/token/a/", "help", "clear", "h", "c", "create /a/b/c", "rm /a", "create a/b/c", "rm a/b/c", "rm a", "cd tw", "info", "headers", "headers wow=kereen", "save", "cp /c .", "cp /c/d .", "cp /c/d c", "cp /c/d c/d", "l", "rm /twitter/c", "ls", "rm /twitter/d"]
  @@pwd = "/twitter/"
  #env_end

  # @@spaces['/']._set("go=lang")
  # @@spaces['/a'] = SpaceBase.new(@@spaces['/']) 
END

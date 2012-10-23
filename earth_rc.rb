Console.instance_eval <<END
  spaces = []
  #space_start
  spaces << '/b/'
  spaces << '/c/'
  spaces << '/d/'
  spaces << '/stripe/'
  spaces << '/twitter/b/c/d/'
  #space_end
  spaces.each do |row|
    @repl = row ; _add(true)
  end
END

VConsole::Commands.class_eval <<END
  #env_start
  @@history = ["send", "save", "save", "save", "save", "save", "send", "ls", "save", "send", "cd strip", "cd stripe", "send", "save", "save", "save"]
  @@pwd = "/stripe/"
  #env_end
 
  headers = {}
  #headers_start
  headers['/'] = {:CONTENT_TYPE=>"application/x-www-form-urlencoded", :Authorization=>"Basic YzNqdDdmRzYzZ1JkdTVweEJuWXkxMmZUT0RQVkRuQXE6\n"}
  #headers_end  
  headers.each do |v|
    tmp = @@spaces[v[0]].instance_variable_get("@headers")
    v[1].each{ |x| tmp[x[0]] = x[1] }
  end

  vars = {}
  #vars_start
  vars['/'] = {:timeout=>15, :url=>"http://localhost:3000"}
  vars['/b/'] = {:wow=>"kereeeen"}
  vars['/twitter/'] = {:go=>"language"}
  #vars_end
  vars.each do |v|
  	tmp = @@spaces[v[0]].instance_variable_get("@vars")
  	v[1].each{ |x| tmp[x[0]] = x[1] }
  end
  # @@spaces['/']._set("go=lang")
  # @@spaces['/a'] = SpaceBase.new(@@spaces['/']) 
END

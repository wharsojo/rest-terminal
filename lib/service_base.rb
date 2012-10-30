require 'base64'
require 'faraday'

class ServiceBase
  attr_reader :path
  def initialize(vc=nil,path='/',silent=false)
    @path     = path
    @response = {}
    @parent   = vc 
    reset(%w(headers body vars))
    if File.exists?("services#{path}service.rb")
      instance_eval(IO.read("services#{path}service.rb"))
    end
  end

  def _info(prm)
    headerx = headers
    bodyx = bodies
    varx = vars
    line = ('-'*65)

    puts ('='*65).yellow
    # puts "[#{varx[:conn]}] #{varx[:url]}".intense_blue
    puts line.blue
    puts "headers".intense_green 
    puts headerx.pj
    puts line.blue
    puts "body".intense_green
    puts bodyx.pj
    puts line.blue
    puts "vars".intense_green
    puts vars.pj
    ''
  end

  def _headers(prm)
    prm==[] ? show_vars(headers,'headers') : set_value(:headers,prm)
  end

  def _body(prm)
    prm==[] ? show_vars(bodies,'body') : set_value(:bodies,prm)
  end

  def _vars(prm)
    prm==[] ? show_vars(vars,'vars') : set_value(:vars,prm)
  end

  def _response(prm)
    puts prm==[] ? @response.pj : @response[prm[0].to_sym].pj
    "Inspecting..."
  end

  def _reset(prm)
    reset(prm)
    show_vars(headers,'headers')
    show_vars(bodies,'bodies')
    show_vars(vars,'vars')
    save_vars
  end

  def _send(prm)
    #p Rest::Terminal.instance_variable_get("@response")
    headerx = headers
    bodyx = bodies
    varx = vars
    line = ('-'*65)

    puts line.yellow
    puts "[#{varx[:conn]}] #{varx[:url]}".intense_blue
    puts line.blue
    puts "request".intense_green 
    puts({"headers" => headerx,"body" => bodyx}.pj)
    begin
      conn = Faraday.new(:url => varx[:url])
      resp = conn.send(varx[:conn]) do |req|
        req.body = body_join 
        req.headers = headerx
      end.env
      if /application\/json/=~resp[:response_headers]["content-type"]
        body = JSON.parse(resp[:body])
      else
        body = resp[:body]
      end
      @response = {
        :status => resp[:status],
        :headers => resp[:response_headers],
        :body => body
      }
      Rest::Terminal.instance_variable_set("@response",@response)
      puts line.red
      puts "response".intense_green 
      puts @response #.pj #[:response_headers].inspect
      save_vars
      ""
    rescue Faraday::Error::ConnectionFailed => e
      "#{e}"
    end

  end

  def headers(up=true)
    inheritances(:headers,up).select{|k,v|v && !v.empty?}
  end

  def bodies(up=true)
    inheritances(:bodies,up).select{|k,v|v && !v.empty?}
  end

  def vars(up=true)
    inheritances(:vars,up).select{|k,v|v && !v.empty?}
  end

  def inheritances(key,up)
    @_tmp = {}
    if @parent && up
      v_par = @parent.send(:inheritances,key,up)
      @_tmp.merge!(v_par) if v_par
    end
    v_ins = instance_variable_get("@#{key}")
    @_tmp = @_tmp.merge(v_ins) if v_ins
    @_tmp
  end

  private
  # ex: rest reset body
  # reset value to def_value or empty/[]  
  def reset(prm)
    params = prm - (prm - %w(headers body vars))
    params.each do |x|
      @headers = (@parent ? {} : def_headers) if x=='headers'
      @bodies  = (@parent ? {} : def_bodies) if x=='body'
      @vars    = (@parent ? {} : def_vars) if x=='vars'
    end
  end

  def show_send_headers
    show_vars(headers,'headers')
  end

  def show_send_bodies
    show_vars(bodies,'body')
  end

  def show_send_vars
    v1 = [:conn,:url,:body]
    v2 = vars
    show_vars(Hash[v1.collect{|x|[x,v2[x]]}],'vars')
  end

  def show_vars(items,key)
    line = ('-'*65)
    puts line.blue
    puts key.intense_green 
    puts items.pj
  end

  def body_join
    bodies.collect do |k,v|
      "#{k}=#{v}"
    end.join("&")
  end

  def set_value(key,prm)
    item = instance_variable_get("@#{key}")
    prm.each do |p|
      k,v = p.split('=',2).collect{|x|x.strip}
      if k[/\*/]
        p "k,v: #{k} #{v.class} #{@bodies.inspect}"
        self.send(key).select{|x,y|x[/#{k}/]}.each do |x,y|
          if v=='nil'
            item.delete(x)
          elsif v=='*'
            item[x] = y
          else
            item[x] = v
          end
        end
      else
        if v=='nil'
          item.delete(k.to_sym)
        else
          item[k.to_sym] = v
        end
      end
    end
    show_vars(item,key)
    save_vars
    "OK"
  end

  def def_headers
    {
      :"content-type" => 'application/json'
    }
  end

  def def_bodies
    {

    }
  end

  def def_vars
    {
      :conn => 'get',
      :url => 'http://localhost:3000'
    }
  end

  def save_vars
    b = ['']
    b << "response = #{@response.inspect}"
    b << "headers  = #{@headers.inspect}"
    b << "bodies   = #{@bodies.inspect}"
    b << "vars     = #{@vars.inspect}"
    c = b.join("\n")
    s = "#vars_start(.*)#vars_end" 

    if !File.exists?("services#{@path}service.rb")
      `cp service.rb services#{@path}`
    end

    code = IO.read("services#{@path}service.rb")
    #-----------------------------------------
    x = code.split(/#{s}/m)
    x[1] = "#vars_start#{c}\n#vars_end"
    #-----------------------------------------
    IO.write("services#{@path}service.rb", x.join)
  end
end
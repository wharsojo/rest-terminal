require 'base64'
require 'faraday'
require 'shellwords'

class SpaceBase
	def initialize(vc=nil,path='/',silent=false)
    p "class: #{self.class} : path: #{path}"  if silent
    @resp    = nil
    @headers = (vc && def_headers==vc.headers) ? {} : def_headers
    @vars    = (vc && def_vars   ==vc.vars)    ? {} : def_vars
    @path    = path
    @parent  = vc 
  end

  def _headers(prm)
    prm=='' ? show_vars(headers) : set_value(:headers,prm)
  end

  def _inspect(prm)
    puts prm=='' ? @resp.inspect : @resp[prm.to_sym].inspect
    "Inspecting..."
  end

  def _vars(prm)
    prm=='' ? show_vars(vars) : set_value(:vars,prm)
  end

  def _send(prm)
    puts "send: #{@path}"
    show_send_headers
    show_send_vars
    conn = Faraday.new(:url => @vars[:url])
    @resp = conn.send(@vars[:conn]) do |req|
      req.body = @vars[:body] if @vars[:body]
      req.headers = headers
    end.env
    if @headers[:CONTENT_TYPE]=="application/json"
      puts @resp[:body].pj
    else
      puts @resp[:body]
    end
    "#{self.class} Command Send"
  end

  def headers(up=true)
    inheritances(:headers,up)
  end

  def vars(up=true)
    inheritances(:vars,up)
  end

  private 
  def show_send_headers
    show_vars(@headers)
  end

  def show_send_vars
    v1 = [:conn,:url,:body]
    v2 = vars
    show_vars(Hash[v1.collect{|x|[x,v2[x]]}])
  end

  def inheritances(key,up)
    @_tmp = {}
    @_tmp.merge!(@parent.send(key)) if @parent && up
    @_tmp.merge!(instance_variable_get("@#{key}"))
    @_tmp
  end

  def set_value(key,prm)
    item = instance_variable_get("@#{key}")
    wrds = Shellwords::shellwords(prm)
    wrds.each do |itm|
      v1,v2 = itm.split('=',2).collect{|x|x.strip}
      item[v1.to_sym] = v2
    end
    "#{wrds.length} items"
  end

  def show_vars(items)
    items.each do |v|
      puts "#{v[0]} = #{v[1]}"
    end
    "#{items.length} items"
  end

  def def_headers
    {
      :CONTENT_TYPE => 'application/json'
    }
  end

  def def_vars
    {
      :timeout => 15,
      :conn => 'get',
      :url => 'http://localhost:3000'
      #:body => standard post params
        # { 
        #   "card"=> {
        #     "number"=>"4242424242424242", 
        #     "exp_month"=>"05", 
        #     "exp_year"=>"2013", 
        #     "cvc"=>"123"
        #   }}.to_json # json style post params
    }
  end
end
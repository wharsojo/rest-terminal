require 'json'
require 'base64'
require 'faraday'

class SpaceBase
	def initialize(vc=nil,path='/')
    @headers = (vc && def_headers==vc.headers) ? {} : def_headers
    @vars    = (vc && def_vars   ==vc.vars)    ? {} : def_vars
    @path    = path
    @parent  = vc 
  end

  def headers(up=true)
    @_tmp = {}
    @_tmp.merge!(@parent.headers) if @parent && up
    @_tmp.merge!(@headers)
    @_tmp
  end

  def vars(up=true)
    @_tmp = {}
    @_tmp.merge!(@parent.vars) if @parent && up
    @_tmp.merge!(@vars)
    @_tmp
  end

  def _info(prm)
    vars.each do |v|
      puts "#{v[0]} = #{v[1]}"
    end
    'Variables info'
  end

  def _send(prm)
    conn = Faraday.new(:url => @vars[:url])
    @resp = conn.post do |req|
      req.body = @vars[:body] if @vars[:body]
      req.headers = headers
    end.env
    puts @resp[:body]
    "#{self.class} Command Send"
  end

  def _set(prm)
    tmp = prm.split('=').collect{|x|x.strip}
    @vars[tmp[0].to_sym] = tmp[1]
    'OK'
  end

  private 

  def def_headers
    {
      :CONTENT_TYPE => 'application/json'
    }
  end

  def def_vars
    {
      :timeout => 15,
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
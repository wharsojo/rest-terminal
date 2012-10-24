module Space
  class Twitter < SpaceBase
    def _send(prm)
      puts "send: #{@path}"
      'Twitter Command Send'
    end
  end
end
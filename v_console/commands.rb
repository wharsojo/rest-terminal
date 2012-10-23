class VConsole
  module Commands
    @@history ||= []
    @@spaces  ||= {
      "/" => SpaceBase.new
    }
    @@pwd = "/"

    def __

    end

    def _cd
      @_tmp = "#{@repl}/" if @repl[-1]!='/'
      @_tmp = "#{@@pwd}#{@_tmp}" if @_tmp[0] != '/'
      if @@spaces[@_tmp]
        @@pwd = @_tmp
        @_status = 'OK'
      end
    end

    def _clear
      # @@history = []
      print "\033[2J\033[1;1H"
    end

    def _history
      @@history.each { |itm| puts itm.intense_cyan }
    end

    def _info
      @_status =  @@spaces[@@pwd]._info(@repl)
    end

    def _add(silent=false)
      @_ttl = 0
      @repl.split(/ +/).each do |space|
        @_tmp = '/'
        full_path(space).gsub('/',' ').strip.split(' ').each do |itm|
          @_old = @_tmp
          @_tmp = "#{@_tmp}#{itm}/" 
          if !@@spaces[@_tmp]
            @_ttl += 1
            old = @@spaces[@_old]
            kls = spaced(@_tmp) 
            kls = old.class if !kls
            puts @_tmp.space_color if !silent
            @@spaces[@_tmp] = kls.new(old,@_tmp) 
          end
        end
      end
      write_spaces if !silent
      @_status = "#{@_ttl} space Created!"
    end

    def _rm
      @_ttl = 0
      @repl.split(/ +/).each do |space|
        @_tmp = full_path(space)
        next if !@@spaces[@_tmp]
        grep(@_tmp,:desc).each do |itm|
          @_ttl += 1
          puts itm.space_color
          @@spaces.delete(itm)
        end
      end
      @_status = "#{@_ttl} space Removed!"
    end

    def _pwd
      @_status = "\"#{@@pwd}\""
    end

    def _reload
      if @repl == 'reload'
        load 'space_base.rb'
        load 'commands.rb'
        load 'v_console.rb'
        VConsole.send(:include, VConsole::Commands)
        puts '> reloading...'
      end
    end

    def _save
      write_spaces
      @_status = 'OK'
    end

    def _send
      @_status = @@spaces[@@pwd]._send(@repl)
    end

    def _set
      @_status = @@spaces[@@pwd]._set(@repl)
    end

    def _ls
      path = (@repl[0]=='/') ? @repl : "*#{@repl}"
      spaces = grep(path)
      spaces.each do |spc|
        colr = spc.space_color
        colr = "#{colr}#{'(*)'.red if spc==@@pwd}"
        puts colr
      end
      @_status = "List Spaces: #{spaces.length}"
    end

    alias :_create :_add
    alias :_remove :_rm
    alias :_spaces :_ls

    private 

    def spaced(prm)
      c = Space.constants
      s = c.collect{|x|"/#{x.to_s.downcase}/"}
      i = s.index(prm)
      Space.const_get(c[i]) if i
    end

    def space_path(spc)
      (spc[0] == '/')  ? spc : "#{@@pwd}#{spc}"
    end

    def full_path(spc)
      spc = "#{spc}/" if spc[-1]!='/'
      space_path(spc)
    end

    def grep(rgx,sort=:asc)
      puts "#{@@spaces.keys.inspect} : #{rgx}"
      keys = @@spaces.keys.select{|x|/^#{rgx}/=~x}.sort #_by{|x|x.length}
      (sort==:desc) ? keys.reverse : keys
    end

    def write_spaces
      s = "#space_start(.*)#space_end" 
      x = IO.read('./earth_rc.rb').split(/#{s}/m)
      a = @@spaces.keys.sort
      b = ['']

      t = a.length-1
      t.times do |x|
        if !(/#{a[x]}/ =~ a[x+1])
          b << "spaces << '#{a[x]}'"
        end
      end
      b << "spaces << '#{a[t]}'"

      c = b.join("\n  ")
      x[1] = "#space_start#{c}\n  #space_end"
      #-----------------------------------------
      s = "#headers_start(.*)#headers_end" 
      x = x.join.split(/#{s}/m)
      a = @@spaces.keys
      b = ['']

      a.each do |k|
        tmp = @@spaces[k].headers(false)
        b << "headers['#{k}'] = #{tmp.inspect}" if tmp!={}
      end

      c = b.join("\n  ")
      x[1] = "#headers_start#{c}\n  #headers_end"
      #-----------------------------------------
      s = "#vars_start(.*)#vars_end" 
      x = x.join.split(/#{s}/m)
      a = @@spaces.keys
      b = ['']

      a.each do |k|
        tmp = @@spaces[k].vars(false)
        b << "vars['#{k}'] = #{tmp.inspect}" if tmp!={}
      end

      c = b.join("\n  ")
      x[1] = "#vars_start#{c}\n  #vars_end"
      #-----------------------------------------
      s = "#env_start(.*)#env_end" 
      x = x.join.split(/#{s}/m)
      b = ['']
      b << "@@history = #{@@history.inspect}"
      b << "@@pwd = #{@@pwd.inspect}"

      c = b.join("\n  ")
      x[1] = "#env_start#{c}\n  #env_end"
      #-----------------------------------------
      IO.write('./earth_rc.rb', x.join)
    end
  end
end

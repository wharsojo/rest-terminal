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
      @repl = full_path(@repl) if @repl[/\.+/]
      space = grep[0]
      if space
        @@pwd=space
        @_status = "#{space} - OK"
      end
    end

    def _cp
      a,b=@repl.split(/ +/,2).collect{|x|full_path(x)}
      puts "copy from: #{a} to: #{b}".red
      if /^#{a}/=~b
        @_status = "can't copy self tree..."
      else
        cut = a.gsub(/\w\/$/,'').length
        sps = grep(a)
        pd1 = sps[-1].length
        pd2 = pd1 + b.length-1
        sps.each do |src|
          kls = @@spaces[src].class
          tgt ="#{b}#{src[cut,99]}"
          old = tgt.gsub(/\w\/$/,'') 

          msg = "src: #{src.ljust(pd1,' ')} tgt: #{tgt.ljust(pd2,' ')} old: #{old}"
          puts (@@spaces[tgt] ? msg.intense_red : msg.intense_cyan)

          sp1 = @@spaces[old]
          sp2 = @@spaces[tgt] = kls.new(sp1,tgt)

          v = sp1.instance_variable_get("@vars")
          h = sp1.instance_variable_get("@headers")
          sp2.instance_variable_set("@vars",v)
          sp2.instance_variable_set("@headers",h)
        end
        c = 'copied'.intense_cyan
        r = 'replaced!'.intense_red
        @_status = "#{sps.length} spaces #{c}/#{r}"
      end
    end

    def _clear
      print "\033[2J\033[1;1H"
    end

    def _inspect
      @_status =  current_space._inspect(@repl)
    end

    def _history
      @@history.each_with_index do |itm,idx| 
        puts "#{idx.to_s.rjust(2,'0')} > `#{itm.command_color}`"
      end
      @_status = "#{@@history.length} histories"
    end

    def _headers
      @_status =  current_space._headers(@repl)
    end

    def _vars
      @_status =  current_space._vars(@repl)
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
            @@spaces[@_tmp] = kls.new(old,@_tmp,silent) 
          end
        end
      end
      write_spaces if !silent
      @_status = "#{@_ttl} space Created!"
    end

    def _help
      cmd = Commands.instance_methods
      cmd.sort.each_with_index do |itm,idx| 
        puts "#{idx.to_s.rjust(2,'0')} > `#{itm[1,99].intense_cyan}`"
      end
      @_status = "#{cmd.length} commands"
    end

    def _ls
      spaces = grep.each_with_index do |spc,idx|
        colr = "#{spc.space_color}#{'(*)'.red if spc==@@pwd}"
        colr = "#{idx.to_s.rjust(2,'0')} > `#{colr}`"
        puts colr
      end
      @_status = "List Spaces: #{spaces.length}"
    end

    def _rm(silent=false)
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
      write_spaces if !silent
      @_status = "#{@_ttl} space Removed!"
    end

    def _pwd
      @_status = "\"#{@@pwd}\" - OK"
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

    def _reset
      @_status = current_space._reset(@repl)
    end

    def _save
      write_spaces
      @_status = 'OK'
    end

    def _send
      if @repl==''
        @_status = current_space._send(@repl)
      else
        spaces = grep.each do |spc|
          @@spaces[spc]._send(spc)
        end
        @_status = "#{spaces.length} Command Send"
      end
    end

    def _set
      @_status = current_space._vars(@repl)
    end

    alias :_h :_history
    alias :_info :_vars
    alias :_create :_add
    alias :_remove :_rm
    alias :_spaces :_ls
    alias :_i :_inspect
    alias :_c :_clear
    alias :_l :_ls

    private 

    def current_space
      @@spaces[@@pwd]
    end

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
      x = "#{@@pwd} "
      l = x.count('/')+1
      dots = spc[/\.+/]
      if dots && 
        set = l-dots.length
        set = 1 if set < 1
        path_up = x.split(/\//)[0,set].join('/')
        spc.gsub!(/\.+/,path_up)
      end
      # if spc=='.'
      #   @@pwd
      # else
      spc = "#{spc}/" if spc[-1]!='/'
      space_path(spc)
      # end
    end

    def grep(rgx=nil,sort=:asc)
      rgx = (@repl[0]=='/') ? @repl : "*#{@repl}" if !rgx
      # puts "#{@@spaces.keys.inspect} : #{rgx}"
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

require 'io/console'

class VConsole
  class GetC
    CUp   ="\e[A"
    CDown ="\e[B"
    CRight="\e[C"
    CLeft ="\e[D"
    CBspc ="\x7F"
    ABeol ="\033[1D\033[K"
    AClear="\033[2J"

    C_Erase_line = "\033[2K\r"

    class << self

      def get(row)
        chr = ""
        key = ''
        get_special_key
        until  /\n|\r/ =~ key || key == "\x03"  || 
          key == CUp    || key == CDown ||
          key == CRight || key == CLeft
          if key == CBspc 
            if row.length>0
              row = row[0,row.length-1]
              print ABeol
            end
          else
            if /[a-zA-Z0-9_\-\/=*.: "\&]/ =~ chr
              row = "#{row}#{chr}"
              if chr=='/'
                print chr.red 
              elsif row.strip.split(/ +/).length>1
                print chr.intense_red
              else
                print chr.green
              end
            end
          end

          begin
            system("stty raw -echo")
            key = chr = STDIN.getc.chr
            if(chr=="\e")
              key = "#{chr}#{get_special_key}"
              # chr = ''
              # p "row:#{row}"
              # p "key:#{key}"
            end
          ensure
            system("stty -raw echo")
          end
        end
        [row,key]
      end

      private
      def get_special_key
        s1 = ''
        s2 = ''
        extra_thread = Thread.new{
          s1 = STDIN.getc.chr
          s2 = STDIN.getc.chr
        }
        extra_thread.join(0.00001) # wait for special keys
        extra_thread.kill # kill thread
        "#{s1}#{s2}"
      end
    end
  end
end
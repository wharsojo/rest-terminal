module Rest
  class Terminal
    module CommandsInfo
      private

      def add_line
        "add service folder"
      end

      def body_line
        "view or set var: body"
      end

      def cd_line
        "change current service"
      end

      def headers_line
        "view or set var: headers"
      end

      def history_line
        "view history last command call"
      end

      def info_line
        "show variables :headers, :body, :vars"
      end

      def init_line
        "prepare folder to become rest-terminal services"
      end

      def ls_line
        "list services"
      end

      def pwd_line
        "print current service"
      end

      def reset_line
        "empty variables :headers, :body, :vars"
      end

      def response_line
        "show last response call from 'send'"
      end

      def send_line
        "send Rest Call"
      end

      def vars_line
        "view or set var: vars"
      end
#--------------------------------------------------------
      def add_help
        "add service folder\n" +
        "Ex: rest add google\n".intense_green +
        "add can be perform in direct child path".intense_red
      end

      def body_help
        "view or set var: body\n" +
        "Ex: rest body # show it\n".intense_green +
        "    rest body id=123\n".intense_green +
        "use rest info to know all"
      end

      def cd_help
        "change current service\n" +
        "Ex: rest cd /\n".intense_green +
        "relative / full path"
      end

      def headers_help
        "view or set var: headers\n"
        "Ex: rest headers # show it\n".intense_green +
        "    rest headers timeout=15\n".intense_green +
        "use rest info to know all"
      end

      def history_help
        "view history last command call\n"
        "Ex: rest history".intense_green
      end

      def info_help
        "show variables :headers, :body, :vars\n" +
        "Ex: rest info".intense_green
      end

      def init_help
        "prepare folder to become rest-terminal services\n" +
        "Ex: rest init".intense_green
      end

      def ls_help
        "list services\n" +
        "Ex: rest ls\n".intense_green +
        "add can be perform in direct child path".intense_red
      end

      def pwd_help
        "show current service\n" +
        "Ex: rest pwd".intense_green
      end

      def reset_help
        "empty variables :headers, :body, :vars\n" +
        "Ex: rest reset vars # show it\n".intense_green +
        "    rest reset headers vars\n".intense_green
      end

      def response_help
        "show last response call from 'send'\n" +
        "Ex: rest response".intense_green
      end

      def send_help
        "send Rest Call\n" +
        "Ex: rest send".intense_green
      end

      def vars_help
        "view or set var: vars\n" +
        "Ex: rest vars # show it\n".intense_green +
        "    rest vars url=http://localhost\n".intense_green +
        "use rest info to know all"
      end

    end
  end
end
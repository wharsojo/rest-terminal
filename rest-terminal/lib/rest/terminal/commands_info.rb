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
        "add service folder"
      end

      def body_help
        "view or set var: body"
      end

      def cd_help
        "change current service"
      end

      def headers_help
        "view or set var: headers"
      end

      def history_help
        "view history last command call"
      end

      def info_help
        "show variables :headers, :body, :vars"
      end

      def init_help
        "prepare folder to become rest-terminal services"
      end

      def ls_help
        "list services"
      end

      def pwd_help
        "print current service"
      end

      def reset_help
        "empty variables :headers, :body, :vars"
      end

      def response_help
        "show last response call from 'send'"
      end

      def send_help
        "send Rest Call"
      end

      def vars_help
        "view or set var: vars"
      end

    end
  end
end
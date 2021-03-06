require 'open3'
class Ybur
  class ExRunner

    class Interactor
      def initialize(handler)
        @handler = handler
      end


      def send(line)
        @handler.send_line(line)
      end

      def get
        @handler.get
      end

      def get_number
        @handler.get_number
      end

    end

    class Handler
      attr_reader :interactor
      def initialize(runner, target)
        @interactor = Interactor.new(self)
        @stdin, @stdout, @stderr, @wait_thr = Open3.popen3("ruby",
                                                           "-e", "STDOUT.sync=true",
                                                           "-e", "load($0=ARGV.shift)",
                                                           target)


        @err_printer = Thread.new do
          @stderr.each do |line|
            $stderr.puts "ERR: #{line}"
          end
        end

        @stdout_array = []
        @stdout_reader = Thread.new do
          @stdout.each do |line|
            @stdout_array << line
          end
        end

        @stdin.sync = true
        @stdout.sync = true
        @pid = @wait_thr.pid
        $stderr.puts @pid
        @runner = runner
        # raise @pid.inspect
      end

      def fail!
        begin
          Process.kill("KILL", @pid)
        rescue Errno::ESRCH => e
          $stderr.puts "FIXME: #{e.message}"
        end

        raise Exceptions::RunAborted, "failed"
      end

      def send_line(line)
        ensure_running
        # $stderr.puts "sending line: #{line}"
        @stdin.puts line
      end

      def get
        timeout_at = Time.now + 5

        while true
          if timeout_at < Time.now
            return :timeout
          end

          next_line = @stdout_array.shift
          return next_line.chomp if next_line
        end
      end

      def get_number
        str = get

        unless str.is_a?(String) && str =~ /^\d+$/
          @runner.error("expected number, got #{str.inspect}")
          fail!
        end
        return str.to_i
      end

      def ensure_running
        Process.kill(0, @pid)
      end
    end


    def initialize(ex_result, exercise, target)
      @ex_result = ex_result
      @exercise = exercise
      @handler = Handler.new(self, target)
      @interactor = @handler.interactor
    end

    def interactor
      @interactor
    end

    def check(expected, actual)
      if expected != actual
        error("invalid response")
        error(" got:       #{actual.inspect}")
        error(" should be: #{expected.inspect}")
        @handler.fail!
      end
    end

    def error(msg)
      @ex_result.error(msg)
    end

  end
end
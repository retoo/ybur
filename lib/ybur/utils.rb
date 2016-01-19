class Ybur
  class Utils
    def self.read_line_nonblocking(io)
      buffer = ""
      buffer << io.read_nonblock(1) while buffer[-1] != "\n"

      buffer
    rescue IO::WaitReadable => blocking
      return nil if buffer.empty?
      buffer
    rescue EOFError => eof
      return :eof if buffer.empty?
      buffer
    end

    def self.slurp_nonblocking(io)
      result = []
      while true
        line = read_line_nonblocking(io)
        return result unless line
        result << line
      end
    end

    def self.read_line_timeout(io, timeout)
      wait_until = Time.now + timeout
      while true
        remain_timeout =  wait_until - Time.now
        return :timeout if remain_timeout < 0
        r, _, _ = IO.select([io], [], [],  timeout)
        if r
          line = read_line_nonblocking(io)
          return line if line
        end
      end
    end
  end
end
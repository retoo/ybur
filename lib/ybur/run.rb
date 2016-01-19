class Ybur
  class Run

    class ExResult
      attr_reader :exercise, :state, :target

      def initialize(exercise, target)
        @exercise = exercise
        @target = target
        @state = nil
        @header_printed = false
      end

      def success!
        ensure_no_state!
        @state = :success
      end

      def aborted!
        ensure_no_state!
        @state = :aborted
      end

      def complete!
        if @state.nil?
          success!
        end
      end

      def error(message)
        print_header_if_needed
        $stderr.puts message
      end

      def print_header_if_needed
        return if @header_printed
        @header_printed = true
        $stderr.puts "#{@exercise.name} on #{@target}"
      end

      def ensure_no_state!
        raise "expected no state: #{@state.inspect}" if @state
      end
    end

    def initialize
      @ex_results = []
    end

    def register(ex_result)
      @ex_results << ex_result
    end

    def register_missing(missing)
      @missing = missing

    end


    def error(msg)
      $stderr.puts msg
    end

    def print_result
      @ex_results.each do |exr|
        puts "%s [%s] => %s" % [exr.exercise.name, exr.target, exr.state]
      end
      @missing.each do |m|
        $stderr.puts "missing: #{m}"
      end
    end
  end
end
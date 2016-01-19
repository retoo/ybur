class Ybur
  class Exercise
    attr_reader :name, :path
    def initialize(path)
      @name = File.basename(path, ".rb")
      @path = path
    end

    def check(run, target)
      ex_result = Run::ExResult.new(self,target)
      run.register(ex_result)
      r = ExRunner.new(ex_result, self, target)
      path = @path
      begin
        r.instance_eval do
          ::Kernel.binding.eval(File.read(path), path)
        end
        ex_result.complete!
      rescue Ybur::Exceptions::RunAborted => e
        ex_result.aborted!
        return
      end
    end
  end
end
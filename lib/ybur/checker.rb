require 'set'
class Ybur
  class Checker
    def initialize(suite_folder, folder)
      @run = Run.new
      @suite = Suite.new(suite_folder)
      @folder = folder
      @seen = Set.new
    end

    def check()
      Dir.entries(@folder).each do |name|
        next if name == "." || name == ".."
        path = File.join(@folder, name)

        ex = @suite.get(name)
        if ex.nil?
          @run.error("exercise named #{name} not found in #{@folder}")
          next
        end
        @seen << name

        Dir.entries(path).each do |target_name|
          next unless target_name =~ /\.rb$/
          target_path = File.join(path, target_name)
          ex.check(@run, target_path)
        end
      end
      missing = @suite.all_names.to_set - @seen
      @run.register_missing(missing)
      @run.print_result

    end

  end
end
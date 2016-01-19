class Ybur
  class Suite
    def initialize(folder)
      @folder = folder
      @exercise_by_name = Hash.new
      parse
    end

    def parse
      Dir.entries(@folder).each do |file|
        next if file == "." || file == ".."
        path = File.join(@folder, file)
        ex = Exercise.new(path)
        @exercise_by_name[ex.name] = ex
      end
    end

    def get(name)
      @exercise_by_name[name]
    end

    def all_names
      @exercise_by_name.keys
    end
  end
end
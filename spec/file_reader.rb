class InputReader
  def initialize(input_filename)
    @input_filename = input_filename
  end

  def read_lines
    lines = []
    File.open(@input_filename, "r") do |f|
      lines = f.read.split(/\n/)
      lines.delete("")
    end
    lines
  end
end

class OutputReader
  def initialize(output_filname)
    @filename = output_filname
  end

  def read_lines
    lines = []
    File.open(@filename, "r") do |f|
      lines = f.read.split(/\n/)
    end
    lines
  end
end

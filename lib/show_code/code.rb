module ShowCode
  class Code
    require 'coderay'

    attr :content, :owner, :file, :line, :lines

    def initialize(location)
      @file         = location.file
      file_lines    = File.readlines(@file) if @file

      @line         = real_start_line file_lines, location.line
      related_lines = file_lines[(@line - 1)..-1] || []

      codes         = extract_method_code related_lines
      @lines        = codes.count
      @content      = codes.join
    end

    def real_start_line(file_lines, line)
      return line unless line.zero?

      file_lines.each do |loc|
        line += 1
        return line if /^\s*(class|module)\s+[A-Z]/ === loc
      end
    end

    def extract_method_code(related_lines)
      codes = []
      related_lines.each do |loc|
        codes << loc
        return codes if expression_end?(codes)
      end
      raise SyntaxError, "unexpected $end"
    end

    # refer: https://gist.github.com/judofyr/1373383
    def expression_end?(codes)
      str = codes.join

      catch(:valid) do
        eval("BEGIN{throw :valid}; #{str}")
      end

      # skip , or \
      str !~ /[,\\]\s*\z/
    rescue SyntaxException
      false
    end

    def highlighted(opts = {})
      options = {:line_numbers => true}.merge(opts)
      colorized = CodeRay.scan(content, :ruby).tty
      output = options[:line_numbers] ? add_line_numbers(colorized) : colorized
      "\n%s\n\n" % output
    end

    def add_line_numbers(output)
      line_number = line - 1
      output.split("\n").map do |loc|
        line_number += 1
        "\e[33m#{line_number.to_s.ljust(4, ' ')}\e[0m#{loc}"
      end.join("\n")
    end

    # Example: ShowCode 'ShowCode::Code.new.greet'
    def greet
      puts 'Hello ShowCode!'
    end

  end
end

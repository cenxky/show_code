module ShowCode
  class Code
    require 'coderay'

    attr :content, :owner, :file, :line, :lines

    def initialize(location)
      @file         = location.file
      @line         = location.line
      file_lines    = File.readlines(@file) if @file

      related_lines = file_lines[(@line - 1)..-1] || []
      codes         = extract_method_code related_lines
      @lines        = codes.count
      @content      = codes.join
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
        "\e[33m%i\e[0m #{loc}" % line_number
      end.join("\n")
    end

    # Example: ShowCode 'ShowCode::Code.new.greet'
    def greet
      puts 'Hello ShowCode!'
    end

  end
end

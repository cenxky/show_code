module ShowCode
  class Code

    attr :content, :owner, :file, :lines

    def initialize(location)
      @file         = location.file
      file_lines    = File.readlines(@file) if @file

      related_lines = file_lines[(location.line - 1)..-1] || []
      codes         = extract_method_code related_lines
      @lines        = codes.count
      @content      = codes.join
    end

    def extract_method_code(related_lines)
      codes = []
      related_lines.each do |value|
        codes << value
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

    # Example: ShowCode 'ShowCode::Code.new.greet'
    def greet
      puts 'Hello ShowCode!'
    end

  end
end

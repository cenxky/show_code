module ShowCode
  module SyntaxException

    GENERIC_REGEXPS = [
          /unexpected (\$end|end-of-file|end-of-input|END_OF_FILE)/, # mri, jruby, ruby-2.0, ironruby
          /embedded document meets end of file/, # =begin
          /unterminated (quoted string|string|regexp) meets end of file/, # "quoted string" is ironruby
          /can't find string ".*" anywhere before EOF/, # rbx and jruby
          /missing 'end' for/, /expecting kWHEN/ # rbx
        ]

    RBX_ONLY_REGEXPS = [
      /expecting '[})\]]'(?:$|:)/, /expecting keyword_end/
    ]

    def self.===(ex)
      return false unless SyntaxError === ex
      case ex.message
      when *GENERIC_REGEXPS
        true
      when *RBX_ONLY_REGEXPS
        rbx?
      else
        false
      end
    end

    def self.rbx?
      RbConfig::CONFIG['ruby_install_name'] == 'rbx'
    end

  end
end



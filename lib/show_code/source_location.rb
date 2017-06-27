module ShowCode
  class SourceLocation

    attr :method, :file, :line

    def initialize(target)
      if target.is_a?(String)

        target = target.gsub! '.new', '.allocate'
        klass  = target.split('.')[0..-2].join('.')
        method = target.split('.').last

        # refer:
        # Object.instance_method(:method).bind(User).call(:current).source_location
        # Object.instance_method(:method).bind(User.allocate).call(:name).source_location
        # Object.instance_method(:method).bind(User.second.school.leader).call(:name).source_location

        @method = Object.instance_method(:method).bind(eval(klass)).call(method)
      elsif target.is_a?(Method) || target.is_a?(UnboundMethod)
        @method = target
      else
        raise ArgumentError, 'bad argument (expected Method object or String)'
      end

      @file, @line = @method.source_location

    end

  end
end

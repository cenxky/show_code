module ShowCode
  class SourceLocationError < StandardError; end

  class SourceLocation
    attr :method, :file, :line

    def initialize(target)
      if target.is_a?(String)
        arr    = target.gsub('.new.', '.allocate.').split('.')
        klass  = arr[0..-2].join('.')
        method = arr[-1]

        # refer:
        # Object.instance_method(:method).bind(User).call(:current).source_location
        # Object.instance_method(:method).bind(User.allocate).call(:name).source_location
        # Object.instance_method(:method).bind(User.second.school.leader).call(:name).source_location

        @method = Object.instance_method(:method).bind(eval(klass)).call(method)
      elsif target.is_a?(Method) || target.is_a?(UnboundMethod)
        @method = target
      else
        raise ArgumentError, 'bad argument (expected Method object or Chaining string)'
      end

      if @method.source_location.nil?
        raise SourceLocationError, 'cannot find the method source location'
      else
        @file, @line = @method.source_location
      end

    end

  end
end

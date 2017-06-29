module ShowCode
  class SourceLocationError < StandardError; end
  class ModuleNotFound < StandardError; end

  class SourceLocation
    attr :method, :file, :line

    def initialize(target)
      if target.is_a?(String)
        arr    = target.gsub('.new.', '.allocate.').split('.')
        klass, method = arr[0..-2].join('.'), arr[-1]
        klass, method = based_on_klass_method(target) if arr.size == 1 # if hope view Class/Module source codes

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
        raise SourceLocationError, 'Could not find the method source location'
      else
        @file, line = @method.source_location
        @line ||= line
      end

    end

    private

    # find class first singleton method or first instance_method
    def based_on_klass_method(klass)
      _class = eval(klass)

      regroup_klass = if !(method = _class.instance_methods(:false)[0]).nil?
        klass + '.allocate'
      elsif !(method = _class.methods(:false)[0]).nil?
        klass
      else
        raise ModuleNotFound, "Could not find #{klass}"
      end

      @line = 0; [regroup_klass, method]
    end

  end
end

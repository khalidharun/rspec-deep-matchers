module Deep
  module Matchers

    def deep_include(expected)
      DeepInclude.new(expected)
    end

    class DeepInclude

      def initialize(expectation, diff = [], path = '')
        @expectation = expectation
        @diff = diff
        @path = path
      end

      def matches?(target)
        result = true
        @target = target
        case @expectation
        when Hash
#          result &&= @target.is_a?(Hash) && @target.keys.count == @expectation.keys.count
          @expectation.keys.each do |key|

            if !@target.has_key?(key)
              @diff.push @path + '/' + key + ': Key missing'
              result = false
            elsif !DeepInclude.new(@expectation[key], @diff, @path + '/' + key.to_s).matches?(@target[key])
              result = false
            end
          end
        when Array
#          result &&= @target.is_a?(Array) && @target.count == @expectation.count
          @expectation.each_index do |index|
            result &&= DeepInclude.new(@expectation[index], @diff, @path + "/[#{index}]").matches?(@target[index])
          end
        else
          if @target != @expectation
            @diff.push @path + ": Values differ (exp: #{@expectation}, act: #{@target})"
            result = false
          end
        end
        result
      end

      def failure_message_for_should
<<EOF
#### expected:
#{@expectation.awesome_inspect}
#### to be included in:
#{@target.awesome_inspect}

Diff:
#{@diff.join("\n")}"
EOF
     end

      def failure_message_for_should_not
<<EOF
#### expected:
#{@expectation.awesome_inspect}
#### to NOT be included in:
#{@target.awesome_inspect}

Diff:
#{@diff.join("\n")}"
EOF
      end
    end

  end
end

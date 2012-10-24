module Shoulda
  module Matchers
    module ActiveRecord
      def delegate(attribute)
        DelegateMatcher.new(attribute)
      end

      class DelegateMatcher
        def initialize(attribute)
          @attribute = attribute
        end

        def to(relationship)
          @relationship = relationship
          self
        end

        def prefix(value)
          @prefix = value
          self
        end

        def allowing_nil(value)
          @allowing_nil = value
          self
        end

        def matches?(subject)
          @subject = subject
          mock_subject
          validates!
        end

        def failure_message
          "Expected #{expectation} #{@problem}"
        end

        def negative_failure_message
          "Did not expect #{expectation}"
        end

        def description
          "attribute #{attribute_normalized} should be delegated to #{@relationship}"
        end

        private

        def validates!
          validates_delegated! && validates_nil!
        end

        def validates_delegated!
          begin
            @subject.send(attribute_normalized) == default_value
          rescue NoMethodError
            @problem = "but method not exists"
            false
          end
        end

        def validates_nil!
          return true unless @allowing_nil

          begin
            mock_subject_with_nil
            @subject.send(attribute_normalized) == nil
          rescue RuntimeError
            @problem = "but #{@relationship} is null"
            false
          end
        end

        def attribute_normalized
          if @prefix
            "#{@relationship}_#{@attribute}"
          else
            @attribute
          end
        end

        def default_value
          'some_value'
        end

        def expectation
          "#{@attribute}, #{prefix_message}, delegated to #{@relationship}"
        end

        def prefix_message
          if @prefix
            "with prefix"
          else
            "without prefix"
          end
        end

        def mock_subject
          @subject.class_eval <<-EOF
            def #{@relationship}
              @_relationship ||= OpenStruct.new(:#{@attribute} => '#{default_value}')
            end
          EOF
        end

        def mock_subject_with_nil
          reset_mock
          @subject.class_eval <<-EOF
            def #{@relationship}
              @_relationship ||= OpenStruct.new(:#{@attribute} => nil)
            end
          EOF
        end

        def reset_mock
          @subject.class_eval <<-EOF
            def #{@relationship}
              @_relationship = nil
            end
          EOF
          @subject.send(attribute_normalized)
        end
      end
    end
  end
end

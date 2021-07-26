module Shoulda
  module Matchers
    module ActiveModel
      # Allow use of auto_increment to test models that makes use of auto_increment
      # How to use
      #   it { should auto_increment(:code) }
      #   or
      #   it { should auto_increment(:code).by(:year) }
      #   or
      #   it { should auto_increment(:code).by([:year]) }
      #   or
      #   it { should auto_increment(:code).by([:year]).on(:before_create) }
      #   or
      #   it { should auto_increment(:code).by([:year]) }
      def auto_increment(attr)
        SequenceGeneratorMatcher.new(attr)
      end

      class SequenceGeneratorMatcher < ValidationMatcher
        def by(sequence_group)
          @sequence_group = Array(sequence_group)

          self
        end

        def on(callback)
          @on_callback = callback

          self
        end

        def scope(query_scope)
          @query_scope = query_scope

          self
        end

        def description
          "require to have a call to auto_increment with #{@attribute}"
        end

        def matches?(subject)
          super(subject)

          sequencer_field_valid? && field_group_valid? && sequence_update_callback_valid? && query_scope_valid?
        end

        def failure_message
          sequence_group_message = " by #{@sequence_group}" if @sequence_group
          on_callback_message = " on #{@on_callback}" if @on_callback
          query_scope_message = " scoped by #{@query_scope}" if @query_scope

          "Expected #{@subject.class} auto_increment #{@attribute}#{sequence_group_message}#{on_callback_message}#{query_scope_message}"
        end

        private

        def sequencer_field_valid?
          @subject.sequencer_field == @attribute
        end

        def field_group_valid?
          @sequence_group.nil? || subject_sequence_group.sort == @sequence_group.sort
        end

        def query_scope_valid?
          @query_scope.nil? || (subject_query_scope == @query_scope)
        end

        def subject_sequence_group
          @subject.sequence_group
        end

        def subject_query_scope
          @subject.query_scope
        end

        def sequence_update_callback_valid?
          return true unless @on_callback

          @subject.sequencer_callback == @on_callback
        end
      end
    end
  end
end

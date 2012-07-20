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
          @sequence_group = sequence_group

          self
        end

        def on(callback)
          @on_callback = callback

          self
        end

        def description
          "require to have a call to auto_increment with #{@attribute}"
        end

        def matches?(subject)
          super(subject)

          sequencer_field_valid? && field_group_valid? && sequence_update_callback_valid?
        end

        def failure_message
          if @on_callback
            "Expected #{@subject.class} auto_increment #{@attribute} by #{@sequence_group} on #{@on_callback}"
          else
            "Expected #{@subject.class} auto_increment #{@attribute} by #{@sequence_group}"
          end
        end

        private

        def sequencer_field_valid?
          @subject.sequencer_field == @attribute
        end

        def field_group_valid?
          subject_sequence_group.sort == @sequence_group.sort
        end

        def subject_sequence_group
          @subject.sequence_group
        end

        def sequence_update_callback_valid?
          return true unless @on_callback

          @subject.sequencer_callback == @on_callback
        end
      end
    end
  end
end

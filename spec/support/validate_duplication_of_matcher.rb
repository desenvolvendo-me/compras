module Shoulda # :nodoc:
  module Matchers
    module ActiveModel # :nodoc:
      # Ensures that the collection does not have more than one item with the specified attribute duplicated
      #
      # Example:
      #   it { should validate_duplication_of(:product_id).on(:purchases) }
      #
      def validate_duplication_of(attr)
        ValidateDuplicationOfMatcher.new(attr)
      end

      class ValidateDuplicationOfMatcher < ValidationMatcher # :nodoc:
        include Helpers

        def initialize(attribute)
          @attribute = attribute
        end

        def on(collection)
          @collection = collection
          self
        end

        def description
          "validate duplication of #{@attribute} on #{@collection}"
        end

        def matches?(subject)
          super(subject)

          duplicated_items_should_be_invalid_except_the_first &&
            diferent_items_should_be_valid &&
            items_marked_for_destruction_should_not_be_considered
        end

        def failure_message
          "Expected #{@subject.class} to not allow duplication of #{@attribute} on #{@collection}"
        end

        private

        def duplicated_items_should_be_invalid_except_the_first
          item_one = @subject.send(@collection).build(@attribute => 1)
          item_two = @subject.send(@collection).build(@attribute => 1)

          @subject.valid?

          item_one.errors.messages[@attribute].nil? &&
          item_two.errors.messages[@attribute].include?(I18n.t('activerecord.errors.messages.taken'))
        end

        def diferent_items_should_be_valid
          @subject.send(@collection).destroy_all

          item_one = @subject.send(@collection).build(@attribute => 1)
          item_two = @subject.send(@collection).build(@attribute => 2)

          @subject.valid?

          item_one.errors.messages[@attribute].nil? &&
          item_two.errors.messages[@attribute].nil?
        end

        def items_marked_for_destruction_should_not_be_considered
          @subject.send(@collection).destroy_all

          item_one = @subject.send(@collection).build(@attribute => 1)
          item_two = @subject.send(@collection).build(@attribute => 1)

          item_two.stub(:marked_for_destruction?).and_return(true)

          @subject.valid?

          item_one.errors.messages[@attribute].nil? &&
          item_two.errors.messages[@attribute].nil?
        end
      end
    end
  end
end

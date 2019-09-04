module NestedSetNumberMethods
  extend ActiveSupport::Concern

  included do
    before_validation :create_masked_number
    before_validation :fill_number

    def splitted_masked_number
      return [] unless masked_number.present?

      masked_number.split('.')
    end

    def splitted_masked_number_filled
      splitted_masked_number.select { |level| level.to_i > 0 }
    end

    def fill_number
      return unless masked_number.present?

      self.number = masked_number.gsub('.', '')
    end

    def create_masked_number
      return unless parent_id || display_number

      if parent.present?
        self.masked_number = [self.parent.masked_number, display_number].join('.')
      else
        self.masked_number = display_number
      end
    end
  end
end

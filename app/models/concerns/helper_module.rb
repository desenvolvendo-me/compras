module HelperModule
  extend ActiveSupport::Concern

  included do
    def to_number_to_currency(value,unit = '')
      ActionController::Base.helpers.number_to_currency(value,unit: @unit)
    end
  end

end
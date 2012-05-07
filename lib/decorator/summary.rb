class Decorator < ActiveSupport::BasicObject
  module Summary
    def summary
    end

    def summary?
      summary.present?
    end
  end
end

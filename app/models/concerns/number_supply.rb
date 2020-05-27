module NumberSupply
  extend ActiveSupport::Concern

  included do
    before_update :set_number

    validates :year, presence: true

    def set_number
      klass = self.class.name

      number = klass.classify.constantize.maximum(:number, conditions: ["compras_#{klass.pluralize.underscore}.year = '#{self.year}'"])
      if number.present?
        self.number = number + 1
      else
        self.number = 1
      end
    end
  end
end
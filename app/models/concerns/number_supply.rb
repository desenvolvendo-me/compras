module NumberSupply
  extend ActiveSupport::Concern

  included do
    before_create :set_number

    validates :year, presence: true

    def set_number
      klass = self.class.name

      number = 0
      so = klass.classify.constantize.maximum(:number, conditions: ["compras_#{klass.pluralize.underscore}.year = '#{self.year}'"])
      if so.present?
        number = so
      end
      self.number = "#{(number.to_i + 1)}/#{self.year}"
    end
  end
end
class PresenceAtLeastOneValidator < ActiveModel::EachValidator
  # Validates that AT LEAST ONE of the specified attributes are not blank (as defined by Object#blank?).
  #
  # ==== Examples
  #
  #    class Product < ActiveRecord::Base
  #       validates :name, :price, :presence_at_least_one => true
  #    end
  #
  #    >> product = Product.new
  #    >> product.valid?
  #    => false
  #    >> [product.errors[:name], :product.errors[:price]]
  #    => ['presence_at_least_one translate message error', 'presence_at_least_one translate message error']
  #
  #    >> product.name = 'Donate a Macbook to Tomas!'
  #    >> product.valid?
  #    => true
  #
  def validate(record)
    if all_specified_attributes_are_blank?(record)
      attributes.each { |attribute| record.errors.add(attribute, :presence_at_least_one) }
    end
  end

  def all_specified_attributes_are_blank?(record)
    attributes.all? { |attribute| record.send(attribute).blank? }
  end
end
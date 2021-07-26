class CantBeUpdatedValidator < ActiveModel::EachValidator
  # Ensure that an attribute can not be updated
  #
  # Examples
  #
  # class User < ActiveRecord::Base
  #   validates :name, :cant_be_updated => true
  #   validates :login, :cant_be_updated => true, :if => :confirmed?
  # end
  #
  def validate_each(record, attribute, value)
    if record.persisted? && record.send("#{attribute}_changed?")
      record.errors.add(attribute, :cant_be_updated, options)
    end
  end
end

class AddPropertyRegistrationToProperties < ActiveRecord::Migration
  def up
    add_column :properties, :property_registration, :string

    #Property.reset_column_information
    #Property.find_each do |property|
      #property_registration = PropertyRegistration.new(property.field_values.ordered_by_field_id)
      #property.update_column(:property_registration, property_registration.format)
    #end
  end

  def down
    remove_column :properties, :property_registration
  end
end

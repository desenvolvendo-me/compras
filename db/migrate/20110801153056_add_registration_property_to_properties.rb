class AddRegistrationPropertyToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :registration_property, :string
  end
end

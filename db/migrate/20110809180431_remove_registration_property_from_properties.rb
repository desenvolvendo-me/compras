class RemoveRegistrationPropertyFromProperties < ActiveRecord::Migration
  def up
    remove_column :properties, :registration_property
  end

  def down
    add_column :properties, :registration_property, :string
  end
end

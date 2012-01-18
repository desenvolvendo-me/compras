class CreatePropertySettings < ActiveRecord::Migration
  def change
    create_table :property_settings do |t|
      t.boolean :use_section_street
      t.boolean :unique_property_registration
      t.boolean :display_disable_properties

      t.timestamps
    end
  end
end

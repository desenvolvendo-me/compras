class CreateTypeOptions < ActiveRecord::Migration
  def change
    create_table :type_options do |t|
      t.integer :economic_registration_setting_id
      t.string :name

      t.timestamps
    end
    add_index :type_options, :economic_registration_setting_id
    add_foreign_key :type_options, :economic_registration_settings
  end
end

class CreateMaterialsClassesProviders < ActiveRecord::Migration
  def change
    create_table :materials_classes_providers, :id => false do |t|
      t.integer :materials_class_id
      t.integer :provider_id
    end

    add_index :materials_classes_providers, :materials_class_id
    add_index :materials_classes_providers, :provider_id

    add_foreign_key :materials_classes_providers, :materials_classes
    add_foreign_key :materials_classes_providers, :providers
  end
end

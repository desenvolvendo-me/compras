class AddCodeToValueSectionStreets < ActiveRecord::Migration
  def change
    add_column :value_section_streets, :code, :string
  end
end

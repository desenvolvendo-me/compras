class AddLevelToLegalNatures < ActiveRecord::Migration
  def change
    add_column :legal_natures, :level_of_nature, :string
  end
end

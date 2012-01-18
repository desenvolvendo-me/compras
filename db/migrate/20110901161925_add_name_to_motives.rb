class AddNameToMotives < ActiveRecord::Migration
  def change
    add_column :motives, :name, :string
  end
end

class AddMessageToSplittings < ActiveRecord::Migration
  def change
    add_column :splittings, :message, :text
  end
end

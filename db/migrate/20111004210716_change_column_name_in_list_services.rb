class ChangeColumnNameInListServices < ActiveRecord::Migration
  def up
    change_column :list_services, :name, :text
  end

  def down
    change_column :list_services, :name, :string
  end
end

class AddSourceToRevenues < ActiveRecord::Migration
  def change
    add_column :revenues, :source, :string
  end
end

class AddCodeToPeople < ActiveRecord::Migration
  def change
    add_column :people, :code, :string
  end
end

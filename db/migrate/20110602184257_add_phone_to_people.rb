class AddPhoneToPeople < ActiveRecord::Migration
  def change
    add_column :people, :phone, :string, :limit => 14
    add_column :people, :fax, :string, :limit => 14
    add_column :people, :mobile, :string, :limit => 14
  end
end

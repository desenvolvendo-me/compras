class AddPledgeTypeToPledges < ActiveRecord::Migration
  def change
    add_column :pledges, :pledge_type, :string
  end
end

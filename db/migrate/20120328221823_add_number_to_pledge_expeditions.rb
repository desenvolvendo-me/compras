class AddNumberToPledgeExpeditions < ActiveRecord::Migration
  def change
    add_column :pledge_expirations, :number, :integer
  end
end

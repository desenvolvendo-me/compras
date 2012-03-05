class AddSourceToPledgeHistorics < ActiveRecord::Migration
  def change
    add_column :pledge_historics, :source, :string
  end
end

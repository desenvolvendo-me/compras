class DropSubpledgeExpirationsTable < ActiveRecord::Migration
  def change
    drop_table :subpledge_expirations
  end
end

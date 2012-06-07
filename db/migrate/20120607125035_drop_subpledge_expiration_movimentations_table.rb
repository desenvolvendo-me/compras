class DropSubpledgeExpirationMovimentationsTable < ActiveRecord::Migration
  def change
    drop_table :subpledge_expiration_movimentations
  end
end

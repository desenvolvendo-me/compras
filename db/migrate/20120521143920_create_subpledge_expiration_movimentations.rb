class CreateSubpledgeExpirationMovimentations < ActiveRecord::Migration
  def change
    create_table :subpledge_expiration_movimentations do |t|
      t.integer :subpledge_expiration_id
      t.string :subpledge_expiration_modificator_type
      t.integer :subpledge_expiration_modificator_id
      t.decimal :subpledge_expiration_value_was, :precision => 10, :scale => 2
      t.decimal :subpledge_expiration_value, :precision => 10, :scale => 2
      t.decimal :value, :precision => 10, :scale => 2

      t.timestamps
    end

    add_index :subpledge_expiration_movimentations, :subpledge_expiration_id, :name => :index_sem_on_pledge_expiration_id

    add_foreign_key :subpledge_expiration_movimentations, :subpledge_expirations, :name => :sem_subpledge_expiration_id_fk
  end
end

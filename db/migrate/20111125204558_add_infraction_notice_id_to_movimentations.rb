class AddInfractionNoticeIdToMovimentations < ActiveRecord::Migration
  def change
    add_column :movimentations, :infraction_notice_id, :integer
    add_index :movimentations, :infraction_notice_id
    add_foreign_key :movimentations, :infraction_notices
  end
end

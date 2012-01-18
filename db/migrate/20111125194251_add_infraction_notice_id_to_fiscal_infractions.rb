class AddInfractionNoticeIdToFiscalInfractions < ActiveRecord::Migration
  def change
    add_column :fiscal_infractions, :infraction_notice_id, :integer
    add_index :fiscal_infractions, :infraction_notice_id
    add_foreign_key :fiscal_infractions, :infraction_notices
  end
end

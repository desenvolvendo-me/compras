class RemoveCompanyRelatedColumnsFromCreditors < ActiveRecord::Migration
  def change
    change_table :compras_creditors do |t|
      t.remove :choose_simple, :legal_nature_id, :company_size_id
    end
  end
end

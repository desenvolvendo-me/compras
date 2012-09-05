class AddNumberToAgreementAdditives < ActiveRecord::Migration
  def change
    add_column :compras_agreement_additives, :number, :integer
  end
end

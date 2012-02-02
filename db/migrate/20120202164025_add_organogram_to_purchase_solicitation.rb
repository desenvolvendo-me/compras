class AddOrganogramToPurchaseSolicitation < ActiveRecord::Migration
  def change
    add_column :purchase_solicitations, :organogram_id, :integer
    add_foreign_key :purchase_solicitations, :organograms, :column => 'organogram_id'
  end
end

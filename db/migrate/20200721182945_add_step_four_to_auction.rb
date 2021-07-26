class AddStepFourToAuction < ActiveRecord::Migration
  def change
    add_column :compras_auctions, :sensitive_value, :boolean
    add_column :compras_auctions, :variation_type, :string
    add_column :compras_auctions, :minimum_interval, :string
    add_column :compras_auctions, :internet_address, :string
    add_column :compras_auctions, :decree_treatment, :boolean
    add_column :compras_auctions, :document_edict, :string
    add_column :compras_auctions, :name_responsible_disclosure, :string
    add_column :compras_auctions, :cpf_responsible_disclosure, :string
    add_column :compras_auctions, :responsible_dissemination_id, :integer
    add_column :compras_auctions, :disclosure_date, :date
    add_column :compras_auctions, :notice_availability, :datetime
    add_column :compras_auctions, :proposal_delivery, :date
    add_column :compras_auctions, :city, :string
    add_column :compras_auctions, :neighborhood, :string
    add_column :compras_auctions, :street, :string
    add_column :compras_auctions, :telephone, :string
    add_column :compras_auctions, :cell_phone, :string
  end
end

class CreatePriceCollectionProposalAnnuls < ActiveRecord::Migration
  def change
    create_table :price_collection_proposal_annuls do |t|
      t.references :price_collection_proposal
      t.references :employee
      t.date :date
      t.text :description

      t.timestamps
    end
    #index too long, added a custom name
    add_index :price_collection_proposal_annuls, :price_collection_proposal_id, :name => 'price_collection_proposal_annul_proposal_id'
    add_index :price_collection_proposal_annuls, :employee_id
  end
end

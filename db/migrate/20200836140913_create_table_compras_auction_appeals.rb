class CreateTableComprasAuctionAppeals < ActiveRecord::Migration
  def change
    create_table :compras_auction_appeals do |t|
      t.integer :auction_id
      t.date    :appeal_date
      t.string  :related
      t.integer :person_id
      t.text    :valid_reason
      t.text    :auction_committee_opinion
      t.string  :situation
      t.date    :new_envelope_opening_date
      t.time    :new_envelope_opening_time
      t.boolean :viewed
      t.datetime :created_at,                   :null => false
      t.datetime :updated_at,                   :null => false
    end

    add_index :compras_auction_appeals, :auction_id, :name => :ca_auction_id
    add_index :compras_auction_appeals, :person_id, :name => :ca_person_id

    add_foreign_key :compras_auction_appeals, :compras_auctions, column: :auction_id
    add_foreign_key :compras_auction_appeals, :unico_people, column: :person_id
  end

end

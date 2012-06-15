class CreateTableComprasAccreditedRepresentatives < ActiveRecord::Migration
  def change
    create_table "compras_accredited_representatives" do |t|
      t.integer "person_id"
      t.integer "licitation_process_bidder_id"
    end

    add_index "compras_accredited_representatives", ["licitation_process_bidder_id"], :name => "car_licitation_process_bidder_id"
    add_index "compras_accredited_representatives", ["person_id"], :name => "car_person_id"
  end
end

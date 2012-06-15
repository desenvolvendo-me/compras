class CreateTableComprasLicitationProcessPublications < ActiveRecord::Migration
  def change
    create_table "compras_licitation_process_publications" do |t|
      t.integer  "licitation_process_id"
      t.string   "name"
      t.date     "publication_date"
      t.string   "publication_of"
      t.string   "circulation_type"
      t.datetime "created_at",            :null => false
      t.datetime "updated_at",            :null => false
    end

    add_index "compras_licitation_process_publications", ["licitation_process_id"], :name => "clpp_licitation_process_id"
  end
end

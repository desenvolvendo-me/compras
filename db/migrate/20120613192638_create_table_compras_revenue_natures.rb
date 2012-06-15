class CreateTableComprasRevenueNatures < ActiveRecord::Migration
  def change
    create_table "compras_revenue_natures" do |t|
      t.integer  "regulatory_act_id"
      t.string   "classification"
      t.integer  "revenue_rubric_id"
      t.string   "specification"
      t.string   "kind"
      t.text     "docket"
      t.datetime "created_at",             :null => false
      t.datetime "updated_at",             :null => false
      t.integer  "entity_id"
      t.integer  "year"
      t.string   "full_code"
      t.integer  "revenue_category_id"
      t.integer  "revenue_subcategory_id"
      t.integer  "revenue_source_id"
    end

    add_index "compras_revenue_natures", ["entity_id"], :name => "crn_entity_id"
    add_index "compras_revenue_natures", ["regulatory_act_id"], :name => "crn_regulatory_act_id"
    add_index "compras_revenue_natures", ["revenue_category_id"], :name => "crn_revenue_category_id"
    add_index "compras_revenue_natures", ["revenue_rubric_id"], :name => "crn_revenue_rubric_id"
    add_index "compras_revenue_natures", ["revenue_source_id"], :name => "crn_revenue_source_id"
    add_index "compras_revenue_natures", ["revenue_subcategory_id"], :name => "crn_revenue_subcategory_id"
  end
end

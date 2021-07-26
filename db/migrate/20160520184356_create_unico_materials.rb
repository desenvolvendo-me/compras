class CreateUnicoMaterials < ActiveRecord::Migration
  def change
    create_table 'unico_materials' do |t|
      t.integer  'material_class_id'
      t.string   'code'
      t.string   'description'
      t.text     'detailed_description'
      t.integer  'reference_unit_id'
      t.string   'manufacturer'
      t.boolean  'combustible', default: false
      t.string   'material_classification'
      t.boolean  'active',                                    default: true
      t.boolean  'control_amount',                            default: false
      t.boolean  'batch_control'
      t.boolean  'medicine'

      t.datetime 'created_at',                                null: false
      t.datetime 'updated_at',                                null: false
    end

    add_index 'unico_materials', ['material_class_id'], name: 'index_unico_materials_on_material_class_id'
    add_index 'unico_materials', ['reference_unit_id'], name: 'index_unico_materials_on_reference_unit_id'
  end
end

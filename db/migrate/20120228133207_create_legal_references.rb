class CreateLegalReferences < ActiveRecord::Migration
  def change
    create_table :legal_references do |t|
      t.string :description
      t.string :law
      t.string :article
      t.string :paragraph
      t.string :sections
      t.text :synopsis

      t.timestamps
    end
  end
end

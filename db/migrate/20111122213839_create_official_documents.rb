class CreateOfficialDocuments < ActiveRecord::Migration
  def change
    create_table :official_documents do |t|
      t.string :number
      t.string :document_type
      t.date :sent_date
      t.date :delivery_date
      t.string :delivery_way

      t.timestamps
    end
  end
end

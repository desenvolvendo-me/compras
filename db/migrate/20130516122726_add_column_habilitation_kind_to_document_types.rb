class AddColumnHabilitationKindToDocumentTypes < ActiveRecord::Migration
  def change
    add_column :compras_document_types, :habilitation_kind, :string
  end
end

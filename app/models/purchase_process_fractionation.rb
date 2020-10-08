class PurchaseProcessFractionation < Compras::Model
  attr_accessible :year, :material_class_id, :purchase_process_id, :value,
    :object_type, :modality, :type_of_removal

  belongs_to :material_class
  belongs_to :purchase_process, class_name: 'LicitationProcess'

  # TODO material class foi removido por deu erro em produção ao atualziar a processo de compra, analisar e ver pq material_class não ta sendo nil
  validates :year, :purchase_process, :value, :object_type,#, :material_class_id
    presence: true
  validates :type_of_removal, presence: true, unless: :modality
  validates :modality, presence: true, unless: :type_of_removal

  orderize :id
  filterize

  scope :by_material_class_id, ->(material_class_id) do
    where { |query| query.material_class_id.eq(material_class_id) }
  end

  scope :by_year, ->(year) do
    where { |query| query.year.eq(year) }
  end
end

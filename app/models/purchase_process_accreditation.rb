class PurchaseProcessAccreditation < Compras::Model
  attr_accessible :purchase_process_accreditation_creditors_attributes,
                  :licitation_process_id

  belongs_to :licitation_process

  has_many :purchase_process_accreditation_creditors, :dependent => :destroy, :order => :id

  accepts_nested_attributes_for :purchase_process_accreditation_creditors,
                                :allow_destroy => true

  validates :licitation_process, :presence => true
end

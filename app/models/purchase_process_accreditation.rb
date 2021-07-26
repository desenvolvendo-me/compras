class PurchaseProcessAccreditation < Compras::Model
  attr_accessible :purchase_process_accreditation_creditors_attributes,
                  :licitation_process_id

  belongs_to :licitation_process

  has_many :purchase_process_accreditation_creditors, :dependent => :destroy,
           :inverse_of => :purchase_process_accreditation, :order => :id
  has_many :creditors, :through => :purchase_process_accreditation_creditors

  accepts_nested_attributes_for :purchase_process_accreditation_creditors,
                                :allow_destroy => true

  delegate :judgment_form_item?, to: :licitation_process, allow_nil: true
end

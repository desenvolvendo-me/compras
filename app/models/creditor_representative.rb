class CreditorRepresentative < Compras::Model
  attr_accessible :creditor_id, :representative_person_id

  belongs_to :creditor
  belongs_to :representative_person, :class_name => 'Person'

  has_many :purchase_process_accreditation_creditors, :dependent => :restrict

  delegate :name, :identity_document, :to_s,
           :to => :representative_person, :allow_nil => true

  orderize :id

  scope :term, lambda { |q|
    joins { representative_person }.
    where { representative_person.name.like("#{q}%") }
  }
end

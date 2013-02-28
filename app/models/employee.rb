class Employee < Compras::Model
  attr_accessible :individual_id, :position_id, :registration

  belongs_to :individual
  belongs_to :position

  has_one :user, :as => :authenticable

  has_many :purchase_solicitations, :foreign_key => :responsible_id, :dependent => :restrict
  has_many :purchase_solicitation_liberations, :foreign_key => :responsible_id, :dependent => :restrict
  has_many :budget_structure_responsibles, :foreign_key => :responsible_id, :dependent => :restrict
  has_many :licitation_processes, :foreign_key => :responsible_id, :dependent => :restrict
  has_many :direct_purchases, :dependent => :restrict
  has_many :price_collections, :dependent => :restrict
  has_many :price_registrations, :foreign_key => :responsible_id, :dependent => :restrict

  delegate :to_s, :name, :to => :individual

  validates :individual_id, :registration, :uniqueness => { :allow_blank => true }
  validates :individual, :registration, :position, :presence => true

  filterize

  scope :ordered, joins { individual }.order { individual.id }
end

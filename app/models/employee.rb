class Employee < Compras::Model
  attr_accessible :person_id, :position_id, :registration

  belongs_to :person
  belongs_to :position

  has_one :user, :as => :authenticable

  has_many :purchase_solicitations, :foreign_key => :responsible_id, :dependent => :restrict
  has_many :purchase_solicitation_liberations, :foreign_key => :responsible_id, :dependent => :restrict
  has_many :budget_structure_responsibles, :foreign_key => :responsible_id, :dependent => :restrict
  has_many :administrative_processes, :foreign_key => :responsible_id, :dependent => :restrict
  has_many :direct_purchases, :dependent => :restrict
  has_many :price_collections, :dependent => :restrict
  has_many :record_prices, :foreign_key => :responsible_id, :dependent => :restrict

  delegate :to_s, :name, :to => :person

  validates :person_id, :registration, :uniqueness => { :allow_blank => true }
  validates :person, :registration, :position, :presence => true

  filterize

  scope :ordered, joins { person }.order { person.name }
end

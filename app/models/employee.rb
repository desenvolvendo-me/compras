class Employee < ActiveRecord::Base
  attr_accessible :person_id, :position_id, :registration

  belongs_to :person
  belongs_to :position

  has_one :user

  has_many :purchase_solicitations, :foreign_key => :responsible_id, :dependent => :restrict
  has_many :organogram_responsibles, :foreign_key => :responsible_id, :dependent => :restrict
  has_many :administrative_processes, :foreign_key => :responsible_id, :dependent => :restrict
  has_many :direct_purchases, :dependent => :restrict

  delegate :to_s, :name, :to => :person

  validates :person_id, :registration, :uniqueness => true
  validates :person, :registration, :position, :presence => true

  filterize

  scope :ordered, joins { person }.order { person.name }
end

class EventCheckingConfiguration < Compras::Model
  attr_accessible :event, :function, :descriptor_id,
                  :accounts_attributes

  belongs_to :descriptor

  has_many :accounts, :class_name => 'EventCheckingAccount',
           :dependent => :destroy

  accepts_nested_attributes_for :accounts, :allow_destroy => true

  validates :event, :function, :descriptor, :presence => true

  orderize :id
  filterize

  def to_s
    event
  end
end

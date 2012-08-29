class TceSpecificationCapability < Compras::Model
  attr_accessible :description, :capability_source_id, :application_code_id,
                  :agreement_ids

  has_many :capabilities, :dependent => :restrict
  has_many :tce_capability_agreements, :dependent => :destroy
  has_many :agreements, :through => :tce_capability_agreements,
           :dependent => :restrict

  belongs_to :capability_source
  belongs_to :application_code

  delegate :specification, :to => :capability_source, :prefix => true,
           :allow_nil => true
  delegate :specification, :to => :application_code, :prefix => true,
           :allow_nil => true

  validates :description, :capability_source, :application_code,
            :presence => true

  orderize :description
  filterize

  def to_s
    description
  end
end

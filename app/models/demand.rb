class Demand < Compras::Model
  attr_accessible  :name,:final_date, :initial_date,
    :observation, :status, :year,:purchasing_unit_id,
                   :purchase_solicitation_id,
                   :department_ids

  belongs_to :purchase_solicitation, :dependent => :destroy
  belongs_to :purchasing_unit, :dependent => :destroy

  has_many :demand_departments, :dependent => :destroy
  has_many :departments, :through => :demand_departments, :order => :id
  has_many :purchase_solicitations

  has_enumeration_for :status, :with => DemandStatus, :create_helpers => true

  after_create :create_purchase_solicitations

  validates :year,:name, presence: true
  validates :year,:mask => '9999',
             numericality: {
                             only_integer: true,
                             greater_than_or_equal_to: 1900,
                             less_than_or_equal_to: Date.today.year+5
                           }

  orderize "created_at"
  filterize

  scope :term, lambda {|q|
    where {name.like("%#{q}%")}
  }

  def create_purchase_solicitations
    code_maximum = PurchaseSolicitation.maximum('code')
    code_maximum = code_maximum.nil? ? 0:code_maximum + 1

    unless self.purchase_solicitation.nil?
      self.departments.each  do |department|
        pur_sol = PurchaseSolicitation.new(self.purchase_solicitation.attributes)
        pur_sol.id = nil
        pur_sol.code = code_maximum
        pur_sol.department_id = department.id
        pur_sol.demand_id = self.id
        pur_sol.model_request = false
        pur_sol.service_status = PurchaseSolicitationServiceStatus::PENDING
        code_maximum += 1

        self.purchase_solicitation.items.each  do |item|
          pur_sol.items.build(material_id:item.material_id, lot:  item.lot)
        end

        @status = pur_sol.save(validate:false)
      end
    end
  end

  def to_s
    "#{name}"
  end

end
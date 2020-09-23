class Employee < Compras::Model
  attr_accessible :email, :individual_id, :phone, :position_id, :registration

  attr_modal :name, :email, :phone, :position_id, :registration

  belongs_to :individual
  belongs_to :position

  has_one :user, as: :authenticable
  has_one :person, through: :individual

  has_many :purchase_solicitations_with_liberator, class_name: 'PurchaseSolicitation', foreign_key: :liberator_id, dependent: :restrict
  has_many :purchase_solicitations_with_responsible, class_name: 'PurchaseSolicitation', foreign_key: :responsible_id, dependent: :restrict
  has_many :purchase_solicitation_liberations, foreign_key: :responsible_id, dependent: :restrict
  has_many :supply_request_attendances, foreign_key: :responsible_id, dependent: :restrict
  has_many :licitation_processes_with_contact, class_name: 'LicitationProcess', foreign_key: :contact_id, dependent: :restrict
  has_many :price_collections, dependent: :restrict
  has_many :legal_analysis_appraisals, foreign_key: :responsible_id, dependent: :restrict
  has_many :process_responsibles, dependent: :restrict
  has_many :price_collection_proposals, dependent: :restrict

  has_one :street, through: :individual
  has_one :neighborhood, through: :individual

  delegate :to_s, :name, :number, :issuer, :cpf, :zip_code,
           :city, :state, to: :individual, allow_nil: :true
  delegate :email, :phone, to: :individual, allow_nil: :true, prefix: true
  delegate :name, to: :street, allow_nil: true, prefix: true
  delegate :name, to: :neighborhood, allow_nil: true, prefix: true
  delegate :tce_mg_code, to: :city, allow_nil: true, prefix: true
  delegate :acronym, to: :state, allow_nil: true, prefix: true

  validates :email, mail: true, allow_blank: true
  validates :individual_id, :registration, uniqueness: {allow_blank: true}
  validates :individual, :registration, :position, presence: true
  validates :phone, mask: "(99) 9999-9999", allow_blank: true

  scope :ordered, joins { individual }.order { individual.id }

  scope :term, lambda { |q|
    joins(:person).where { person.name.like("%#{q}%") }
  }

  def self.filter(params)
    query = scoped.joins { individual.person }
    query = query.where { email.eq(params[:email]) } if params[:email].present?
    query = query.where { individual.person.name.like("%#{params[:name]}%") } if params[:name].present?
    query = query.where { phone.eq(params[:phone]) } if params[:phone].present?
    query = query.where { position_id.eq(params[:position_id]) } if params[:position_id].present?
    query = query.where { registration.eq(params[:registration]) } if params[:registration].present?
    query
  end

  def email
    super || individual_email
  end

  def phone
    super || individual_phone
  end
end

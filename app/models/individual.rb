class Individual < Persona::Individual
  attr_modal :person, :mother, :father, :birthdate, :gender, :cpf

  has_many :licitation_commission_responsibles, dependent: :restrict
  has_many :licitation_commission_members, dependent: :restrict
  has_many :judgment_commission_advice_members, dependent: :restrict

  has_one :employee
  has_one :street, through: :person
  has_one :neighborhood, through: :person

  validates :cpf, presence: true

  delegate :to_s, :name, :city, :state, :zip_code, :phone, :email,
    to: :person, allow_nil: true
  delegate :number, :issuer, to: :identity, allow_nil: true

  filterize
  orderize :birthdate

  def self.filter(params)
    query = scoped.joins { person }
    query = query.where { birthday.eq(params[:birthday]) } if params[:birthday].present?
    query = query.where { cpf.eq(params[:cpf]) } if params[:cpf].present?
    query = query.where { gender.eq(params[:gender]) } if params[:gender].present?
    query = query.where { father.like("#{params[:father]}%") } if params[:father].present?
    query = query.where { mother.like("#{params[:mother]}%") } if params[:mother].present?
    query = query.where { person.name.like("#{params[:person]}%") } if params[:person].present?

    query
  end
end

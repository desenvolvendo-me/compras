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
end

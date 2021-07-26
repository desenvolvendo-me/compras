class User < Compras::Model
  attr_accessible :email, :login, :profile_id, :password, :password_confirmation
  attr_accessible :authenticable_id, :authenticable_type,
                  :purchasing_unit_ids, :administrator, :activated, :electronic_auction

  attr_modal :login, :email

  devise :database_authenticatable, :recoverable, :validatable, :confirmable,
         :timeoutable

  has_many :user_purchasing_units, :dependent => :destroy, :inverse_of => :user
  has_many :purchasing_units, :through => :user_purchasing_units, :order => :id
  has_many :department_people

  has_enumeration_for :authenticable_type, :with => AuthenticableType,
                      :create_helpers => true, :create_scopes => true

  belongs_to :profile
  belongs_to :authenticable, :polymorphic => true

  has_one :bookmark, :dependent => :destroy

  has_many :roles, :through => :profile

  delegate :updated_at, :to => :profile, :allow_nil => true, :prefix => true

  validates :login, :presence => true, :unless => lambda { |u| !u.persisted? && u.creditor? }
  validates :authenticable_id, :presence => true, :unless => :administrator_or_creditor_or_provider?
  validates :authenticable_id, :uniqueness => {:scope => :authenticable_type}, :allow_blank => true
  validates :profile, :presence => true, :unless => :administrator_or_creditor_or_provider?
  validates :login, :uniqueness => true, :format => /\A[a-z0-9.]+\z/i, :allow_blank => true

  before_create :skip_confirmation!, :if => :administrator?
  after_validation :set_profile_admin
  after_validation :set_name

  validate :authenticable_valid

  filterize
  orderize

  def set_name
    self.name = self.authenticable.name unless self.authenticable.nil?
  end

  def set_profile_admin
    self.administrator = true if self.profile == 'Administrador'
  end

  def password_required?
    return persisted? && !confirmed? if creditor?
    !persisted? || password.present? || password_confirmation.present?
  end

  def to_s
    login.to_s
  end

  def administrator_or_creditor_or_provider?
    administrator? || creditor? || provider?
  end

  def name_and_profile
    case authenticable_type
      when 'Employee'
        name.to_s+' / Pregoeiro'
      when 'Creditor'
        name.to_s+' / Fornecedor'
      when 'Provider'
        name.to_s+' / Fornecedor'
      else
        name.to_s+''
      end
  end


  scope :term, lambda { |q|
    where { login.like("%#{q}%") }
  }

  protected

  def email_required?
    creditor?
  end

  def send_on_create_confirmation_instructions
    super unless creditor?
  end

  def authenticable_valid
    errors["authenticable_id"].each do |message|
      errors.add(:authenticable, message)
    end
    errors["authenticable_type"].each do |message|
      errors.add(:authenticable, message)
    end
  end

end
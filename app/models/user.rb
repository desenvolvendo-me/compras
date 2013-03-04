class User < Compras::Model
  attr_accessible :email, :login, :profile_id, :password, :password_confirmation
  attr_accessible :authenticable_id, :authenticable_type

  attr_modal :email

  devise :database_authenticatable, :recoverable, :validatable, :confirmable,
         :timeoutable

  has_enumeration_for :authenticable_type, :with => AuthenticableType,
                      :create_helpers => true, :create_scopes => true

  belongs_to :profile
  belongs_to :authenticable, :polymorphic => true

  has_one :bookmark, :dependent => :destroy

  has_many :roles, :through => :profile

  delegate :name, :to => :authenticable, :allow_nil => true

  validates :login, :presence => true, :unless => lambda { |u| !u.persisted? && u.creditor? }
  validates :authenticable, :presence => true, :unless => :administrator?
  validates :authenticable_id, :uniqueness => { :scope => :authenticable_type }, :allow_blank => true
  validates :profile, :presence => true, :unless => :administrator_or_creditor?
  validates :login, :uniqueness => true, :format => /\A[a-z0-9.]+\z/i, :allow_blank => true

  before_create :skip_confirmation!, :if => :administrator?

  filterize
  orderize

  def password_required?
    return persisted? && !confirmed? if creditor?
    !persisted? || password.present? || password_confirmation.present?
  end

  def to_s
    login.to_s
  end

  def administrator_or_creditor?
    administrator? || creditor?
  end

  protected

  def email_required?
    creditor?
  end

  def send_on_create_confirmation_instructions
    super unless creditor?
  end
end

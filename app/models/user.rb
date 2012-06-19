class User < Compras::Model
  attr_accessible :email, :login, :profile_id, :password, :password_confirmation
  attr_accessible :authenticable_id, :authenticable_type

  devise :database_authenticatable, :recoverable, :validatable, :confirmable

  belongs_to :profile
  belongs_to :authenticable, :polymorphic => true

  has_one :bookmark, :dependent => :destroy

  delegate :roles, :to => :profile, :allow_nil => true
  delegate :name, :to => :authenticable, :allow_nil => true

  validates :login, :presence => true
  validates :authenticable, :presence => true, :unless => :administrator?
  validates :profile, :presence => true, :if => lambda{ |u| !u.administrator? && !u.creditor? }
  validates :login, :uniqueness => true, :format => /\A[a-z0-9.]+\z/i, :allow_blank => true

  has_enumeration_for :authenticable_type, :with => AuthenticableType, :create_helpers => true

  filterize
  orderize

  def password_required?
    return persisted? && !confirmed? if creditor?
    !persisted? || password.present? || password_confirmation.present?
  end

  def to_s
    login.to_s
  end

  protected

  def email_required?
    false
  end
end

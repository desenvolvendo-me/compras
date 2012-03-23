class User < ActiveRecord::Base
  attr_accessible :email, :login, :profile_id, :password, :password_confirmation
  attr_accessible :employee_id

  attr_modal :email

  devise :database_authenticatable, :recoverable, :validatable

  belongs_to :profile
  belongs_to :employee

  has_one :bookmark, :dependent => :destroy

  delegate :roles, :to => :profile, :allow_nil => true
  delegate :name, :to => :employee, :allow_nil => true

  validates :login, :presence => true
  validates :employee, :profile, :presence => true, :unless => :administrator?
  validates :login, :uniqueness => true, :format => /\A[a-z0-9.]+\z/i, :allow_blank => true

  filterize
  orderize

  def password_required?
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

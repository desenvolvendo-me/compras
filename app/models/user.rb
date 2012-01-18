class User < ActiveRecord::Base
  attr_accessible :name, :email, :login, :profile_id, :password, :password_confirmation

  attr_modal :name, :email

  devise :database_authenticatable, :recoverable, :validatable

  has_one :bookmark, :dependent => :destroy
  belongs_to :profile

  validates :name, :login, :presence => true
  validates :profile, :presence => true, :unless => :administrator?
  validates :login, :uniqueness => true, :format => /\A[a-z0-9.]+\z/i, :allow_blank => true

  filterize
  orderize

  delegate :roles, :to => :profile, :allow_nil => true

  def password_required?
    !persisted? || password.present? || password_confirmation.present?
  end

  def to_s
    name.to_s
  end

  protected

  def email_required?
    false
  end
end

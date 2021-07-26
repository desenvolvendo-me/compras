class Role < Compras::Model
  attr_accessible :profile_id, :controller, :permission

  has_enumeration_for :permission

  belongs_to :profile

  validates :profile, :controller, :permission, :presence => true

  def controller_name
    I18n.translate("controllers.#{controller}")
  end

  after_save :touch_profile

  private

  def touch_profile
    profile.touch
  end
end

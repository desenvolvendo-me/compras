class Role < ActiveRecord::Base
  attr_accessible :profile_id, :controller, :permission

  has_enumeration_for :permission

  belongs_to :profile

  validates :profile, :controller, :permission, :presence => true

  def controller_name
    I18n.translate("controllers.#{controller}")
  end
end

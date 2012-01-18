class Link < ActiveRecord::Base
  attr_accessible :controller_name

  has_and_belongs_to_many :bookmarks

  validates :controller_name, :presence => true, :uniqueness => true

  def self.ordered
    all.sort_by(&:to_s)
  end

  def to_s
    I18n.translate("controllers.#{controller_name}")
  end
end

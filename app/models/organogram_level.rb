class OrganogramLevel < ActiveRecord::Base
  attr_accessible :level, :description, :digits, :organogram_separator, :configuration_organogram_id

  belongs_to :configuration_organogram

  validates :description, :level, :digits, :presence => true

  has_enumeration_for :organogram_separator, :with => OrganogramSeparator, :create_helpers => true

  orderize :level
  filterize

  def to_s
    "#{level} - #{description}"
  end
end

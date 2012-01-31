class OrganogramLevel < ActiveRecord::Base
  attr_accessible :level, :name, :digits, :organogram_separator, :configuration_organogram_id

  belongs_to :configuration_organogram

  validates :name, :level, :digits, :presence => true

  has_enumeration_for :organogram_separator, :with => OrganogramSeparator, :create_helpers => true

  orderize :level
  filterize

  def to_s
    "#{level} - #{name}"
  end
end

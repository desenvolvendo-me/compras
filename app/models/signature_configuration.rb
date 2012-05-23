class SignatureConfiguration < ActiveRecord::Base
  attr_accessible :report, :signature_configuration_items_attributes

  has_enumeration_for :report, :with => SignatureReport

  has_many :signature_configuration_items, :dependent => :destroy, :order => :order

  accepts_nested_attributes_for :signature_configuration_items, :allow_destroy => true

  validates :report, :presence => true

  orderize :id
  filterize

  def to_s
    report_humanize
  end
end

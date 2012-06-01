class CreditorMaterial < ActiveRecord::Base
  attr_accessible :creditor_id, :material_id

  belongs_to :creditor
  belongs_to :material

  validates :creditor, :material, :presence => true
end

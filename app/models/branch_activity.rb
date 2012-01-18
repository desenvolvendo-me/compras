class BranchActivity < ActiveRecord::Base
  attr_accessible :name, :cnae_id, :branch_classification_id

  attr_modal :name, :cnae_id, :branch_classification_id

  belongs_to :cnae
  belongs_to :branch_classification

  validates :name, :presence => true, :uniqueness => { :allow_blank => true }
  validates :cnae, :branch_classification, :presence => true

  filterize
  orderize

  def to_s
    name
  end
end

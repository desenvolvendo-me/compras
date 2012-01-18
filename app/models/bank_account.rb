class BankAccount < ActiveRecord::Base
  attr_accessible :name, :agency_id, :account_number, :originator, :number_agreement

  attr_modal :name, :agency_id, :account_number, :originator, :number_agreement

  belongs_to :agency

  validates :name, :presence => true, :uniqueness => { :allow_blank => true, :scope => :agency_id }
  validates :agency, :account_number, :number_agreement, :originator, :presence => true

  delegate :bank, :bank_id, :to => :agency, :allow_nil => true

  filterize
  orderize

  def to_s
    name
  end
end

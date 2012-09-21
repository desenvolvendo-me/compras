class CheckingAccountStructure < Compras::Model
  attr_accessible :description, :fill, :name, :reference, :tag,
                  :checking_account_structure_information_id,
                  :checking_account_of_fiscal_account_id

  belongs_to :checking_account_of_fiscal_account
  belongs_to :checking_account_structure_information

  validates :checking_account_of_fiscal_account, :name, :tag, :presence => true

  orderize
  filterize

  def to_s
    "#{checking_account_of_fiscal_account} - #{name}"
  end
end

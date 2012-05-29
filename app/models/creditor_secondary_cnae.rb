class CreditorSecondaryCnae < ActiveRecord::Base
  belongs_to :creditor
  belongs_to :cnae
end

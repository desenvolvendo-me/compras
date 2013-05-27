require 'model_helper'
require 'app/models/realigment_price'
require 'app/models/purchase_process_creditor_proposal'

describe RealigmentPrice do
  it { should validate_presence_of :price }

  it { should belong_to :purchase_process_item }
  it { should belong_to(:proposal).class_name('PurchaseProcessCreditorProposal') }
end

require 'model_helper'
require 'app/models/accounting_cost_center'
require 'app/models/pledge_request_item'

describe PledgeRequestItem do
  it { should belong_to :pledge_request }
  it { should belong_to :purchase_process_item }

  describe 'delegations' do
    xit { should delegate(:lot).to(:purchase_process_item).allowing_nil(true).prefix(true) }
    xit { should delegate(:item_number).to(:purchase_process_item).allowing_nil(true).prefix(true) }
    xit { should delegate(:quantity).to(:purchase_process_item).allowing_nil(true).prefix(true) }
    xit { should delegate(:additional_information).to(:purchase_process_item).allowing_nil(true).prefix(true) }
  end

  describe 'validataions' do
    xit { should validate_presence_of :purchase_process_item }
    xit { should validate_presence_of :quantity }
  end
end

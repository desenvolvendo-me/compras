require 'model_helper'
require 'app/models/accounting_cost_center'
require 'app/models/pledge_request_item'

describe PledgeRequestItem do
  it { should belong_to :purchase_solicitation }
  it { should belong_to :material }
  it { should belong_to :pledge_request }
  it { should belong_to :purchase_process_item }
end

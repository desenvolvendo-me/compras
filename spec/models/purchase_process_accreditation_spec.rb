# encoding: utf-8
require 'model_helper'
require 'app/models/purchase_process_accreditation'
require 'app/models/purchase_process_accreditation_creditor'

describe PurchaseProcessAccreditation do
  it { should belong_to(:licitation_process) }

  it { should have_many(:purchase_process_accreditation_creditors).dependent(:destroy) }
  it { should have_many(:creditors).through(:purchase_process_accreditation_creditors) }

  describe "validations" do
    it { should validate_presence_of :licitation_process }
  end
end

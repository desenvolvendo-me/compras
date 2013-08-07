# encoding: utf-8
require 'model_helper'
require 'app/models/descriptor'
require 'app/models/expense_nature'
require 'app/models/budget_structure'
require 'app/models/accounting_account'
require 'app/models/budget_allocation'
require 'app/models/expense_nature'
require 'app/models/reserve_fund'
require 'app/models/accounting_cost_center'
require 'app/models/pledge_request'
require 'app/models/pledge_request_item'

describe PledgeRequest do
  it { should belong_to :purchase_process }
  it { should belong_to :contract }
  it { should belong_to :creditor }

  it { should have_many :items }

  describe 'validations' do
    it { should validate_presence_of :descriptor_id }
    it { should validate_presence_of :budget_allocation_id }
    it { should validate_presence_of :accounting_account_id }
    it { should validate_presence_of :contract }
    it { should validate_presence_of :reserve_fund_id }
    it { should validate_presence_of :purchase_process }
    it { should validate_presence_of :creditor }
    it { should validate_presence_of :amount }
    it { should validate_presence_of :emission_date }
  end

  describe 'delegations' do
    it { should delegate(:expense_nature).to(:budget_allocation).allowing_nil(true).prefix(true) }
    it { should delegate(:balance).to(:budget_allocation).allowing_nil(true).prefix(true) }
    it { should delegate(:descriptor_id).to(:budget_allocation).allowing_nil(true).prefix(true) }
    it { should delegate(:amount).to(:reserve_fund).allowing_nil(true).prefix(true) }
  end

  describe '#to_s' do
    it 'should return the representation' do
      subject.stub creditor: 'Credor', purchase_process: 'Processo de compra'

      expect(subject.to_s).to eq 'Credor - Processo de compra'
    end
  end
end

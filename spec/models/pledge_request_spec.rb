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

  # it { should have_many :items }

  describe 'validations' do
    it { should validate_presence_of :purchase_process }

    describe 'reserve_fund' do
      let(:purchase_process) { double(:purchase_process) }

      context 'when purchase_process is empty' do
        it 'should not validate reserve_fund' do
          subject.valid?

          expect(subject.errors[:reserve_fund_id]).to be_empty
        end
      end

      context 'when purchase_process does not have reserve_funds_available' do
        it 'should not validate reserve_fund' do
          subject.stub(purchase_process: purchase_process)

          purchase_process.stub(:reserve_funds_available).and_return([])

          subject.valid?

          expect(subject.errors[:reserve_fund_id]).to be_empty
        end
      end

      context 'when purchase_process have reserve_funds_available' do
        context 'when reserve_fund_id id different from purchase_process' do
          it 'should validate reserve_fund presence' do
            subject.reserve_fund_id = 15

            reserve_fund = double(:reserve_fund, id: 10)

            subject.stub(purchase_process: purchase_process)

            purchase_process.stub(:reserve_funds_available).and_return([reserve_fund])

            subject.valid?

            #TODO: depende de PO
            expect(subject.errors[:reserve_fund_id]).to include('não pode ficar em branco')
          end
        end

        context 'when reserve_fund_id id equal to purchase_process' do
          it 'should validate reserve_fund presence' do
            subject.reserve_fund_id = 10

            reserve_fund = double(:reserve_fund, id: 10)

            subject.stub(purchase_process: purchase_process)

            purchase_process.stub(:reserve_funds_available).and_return([reserve_fund])

            subject.valid?

            expect(subject.errors[:reserve_fund_id]).to_not include('não pode ficar em branco')
          end
        end
      end
    end
  end

  describe 'delegations' do
    it { should delegate(:budget_allocations_ids).to(:purchase_process).allowing_nil(true).prefix(true) }
    it { should delegate(:amount).to(:reserve_fund).allowing_nil(true).prefix(true) }
  end

  describe '#to_s' do
    it 'should return the representation' do
      subject.stub creditor: 'Credor', purchase_process: 'Processo de compra'

      expect(subject.to_s).to eq ' - Processo de compra'
    end
  end
end

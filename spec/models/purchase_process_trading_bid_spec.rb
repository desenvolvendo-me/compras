require 'model_helper'
require 'app/models/purchase_process_trading_bid'

describe PurchaseProcessTradingBid do
  it { should belong_to :accreditation_creditor }
  it { should belong_to :item }
  it { should belong_to :trading }

  it { should have_one(:creditor).through(:accreditation_creditor) }

  context 'delegations' do
    it { should delegate(:name).to(:creditor).allowing_nil(true).prefix(true) }
    it { should delegate(:lowest_trading_bid).to(:item).allowing_nil(true) }
  end

  context 'validations' do
    it { should validate_presence_of :trading }
    it { should validate_presence_of :accreditation_creditor }
    it { should validate_presence_of :status }
    it { should validate_presence_of :round }
    it { should validate_presence_of :amount }

    it "validates if amount is greater than zero when status is with_proposal" do
      subject.stub(:with_proposal?).and_return(true)

      should_not allow_value(0).for(:amount)
      should_not allow_value(-1).for(:amount)
      should allow_value(1).for(:amount)
    end

    it "does not validate if amount is greater than zero when status is not with_proposal" do
      subject.stub(:with_proposal?).and_return(false)

      should allow_value(0).for(:amount)
      should allow_value(-1).for(:amount)
      should allow_value(1).for(:amount)
    end

    describe 'validate minimum amount' do
      before do
        subject.stub(:validation_context).and_return(:update)
      end

      context 'when status is not with_proposal' do
        before do
          subject.stub(with_proposal?: false)
        end

        it 'should not has error at amount' do
          subject.valid?

          expect(subject.errors[:amount]).to eq []
        end
      end

      context 'when status is with_proposal' do
        before do
          subject.stub(with_proposal?: true)
        end

        context 'when there is a lowest proposal for the item' do
          before do
            subject.stub(lowest_trading_bid_amount: 100.0)
          end

          context 'when amount is lowest than lowest_trading_amount' do
            before do
              subject.amount =  99.0
            end

            it 'should not add error' do
              subject.valid?

              expect(subject.errors[:amount]).to eq []
            end
          end

          context 'when amount is equal to lowest_trading_amount' do
            before do
              subject.amount = 100.0
            end

            it 'should add error to amount' do
              subject.valid?

              expect(subject.errors[:amount]).to include("deve ser menor que 100,00")
            end
          end

          context 'when amount is greater than lowest_trading_amount' do
            before do
              subject.amount = 110.0
            end

            it 'should add error to amount' do
              subject.valid?

              expect(subject.errors[:amount]).to include("deve ser menor que 100,00")
            end
          end
        end

        context 'when there is no lowest proposal for item' do
          before do
            subject.stub(lowest_trading_bid_amount: nil)
            subject.amount = 1
          end

          it 'should not add error' do
            subject.valid?

            expect(subject.errors[:amount]).to eq []
          end
        end
      end
    end
  end

  describe '#percent' do
    context 'when amount is zero' do
      before do
        subject.stub(amount: 0)
      end

      it 'should be nil' do
        expect(subject.percent).to be_nil
      end
    end

    context 'when amount greater than zero' do
      before do
        subject.stub(amount: 10.0)
      end

      context 'when has no lowest_trading_bid_amount' do
        before do
          subject.stub(lowest_trading_bid_amount: nil)
        end

        it 'should be zero' do
          expect(subject.percent).to eq 0
        end
      end

      context 'when lowest_trading_bid_amount is equal to amount' do
        before do
          subject.stub(lowest_trading_bid_amount: 10)
        end

        it 'should be zero' do
          expect(subject.percent).to eq 0
        end
      end

      context 'when lowest_trading_bid_amount is not equal to amount' do
        before do
          subject.stub(lowest_trading_bid_amount: 9.0)
        end

        it 'should calculate the percent value' do
          expect(subject.percent).to eq 11.11
        end
      end
    end
  end
end

require 'model_helper'
require 'app/models/trading_item_closing'

describe TradingItemClosing do
  it { should belong_to :trading_item }
  it { should belong_to :bidder }

  it { should validate_presence_of :trading_item }
  it { should validate_presence_of :status }

  describe 'validates' do
    context 'when status is winner' do
      let(:trading_item) { double(:trading_item) }

      before do
        subject.status = TradingItemClosingStatus::WINNER
        subject.stub(:trading_item => trading_item)
      end

      context 'with bidder' do
        before do
          subject.stub(:bidder => 'bidder')
        end

        context 'when trading_item not allow winner' do
          before do
            trading_item.stub(:allow_winner? => false)
          end

          it 'should not be valid' do
            subject.valid?

            expect(subject.errors[:status]).to include(I18n.t('errors.messages.trading_item_has_not_a_winner'))
          end
        end

        context 'when trading_item allow winner' do
          before do
            trading_item.stub(:allow_winner? => true)
          end

          it 'should be valid' do
            subject.valid?

            expect(subject.errors[:status]).to_not include(I18n.t('errors.messages.trading_item_has_not_a_winner'))
          end
        end
      end

      context 'without a bidder with lowest proposal' do
        it 'should not be valid' do
          subject.valid?

          expect(subject.errors[:status]).to include(I18n.t('errors.messages.must_have_a_winner_bidder'))
        end
      end
    end
  end
end

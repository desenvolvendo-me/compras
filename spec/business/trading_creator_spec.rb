require 'unit_helper'
require 'active_support/core_ext'
require 'app/business/trading_creator'

describe TradingCreator do
  let(:trading_repository) { double(:trading_repository) }
  let(:purchase_process) { double(:purchase_process, id: 10) }
  let(:purchase_item) { double(:purchase_item, id: 3, lot: 1) }
  let(:trading) { double(:trading, id: 2) }
  let(:trading_item_repository) { double(:trading_item_repository) }

  context 'with purchase_process' do
    subject do
      described_class.new(purchase_process, trading_repository: trading_repository,
                         trading_item_repository: trading_item_repository)
    end

    describe '#create' do
      context 'when allow trading auto creation' do
        before do
          purchase_process.stub(:allow_trading_auto_creation? => true)
          purchase_process.stub(items: [purchase_item])
        end

        context 'when judgement form by item' do
          before do
            purchase_process.stub(judgment_form_item?: true, judgment_form_lot?: false)
          end

          it 'should create a new trading whith current year and purchase_process' do
            trading_repository.
              should_receive(:create!).
              with(purchase_process_id: 10).
              and_return(trading)

            trading_item_repository.should_receive(:create!).with(trading_id: 2, item_id: 3)

            expect(subject.create).to eq trading
          end
        end

        context 'when judgement form by lot' do
          let(:purchase_items) { double(:purchase_items) }

          before do
            purchase_process.stub(judgment_form_item?: false, judgment_form_lot?: true)
            purchase_process.stub(items: purchase_items)
          end

          it 'should create a new trading whith current year and purchase_process' do
            trading_repository.
              should_receive(:create!).
              with(purchase_process_id: 10).
              and_return(trading)

            purchase_items.should_receive(:lots).and_return([1])

            trading_item_repository.should_receive(:create!).with(trading_id: 2, lot: 1)

            expect(subject.create).to eq trading
          end
        end
      end

      context 'when not allow trading auto creation' do
        before do
          purchase_process.stub(:allow_trading_auto_creation? => false)
        end

        it 'should do nothing and return nil' do
          trading_repository.should_not_receive(:create!)

          expect(subject.create).to be_nil
        end
      end
    end
  end

  context 'without purchase_process' do
    subject do
      described_class.new(nil, trading_repository: trading_repository,
                          trading_item_repository: trading_item_repository)
    end

    it 'should return nil' do
      trading_repository.should_not_receive(:create!)

      expect(subject.create).to be_nil
    end
  end

  describe '.create!' do
    let(:trading_creator_instance) { double(:trading_creator_instance) }

    it 'should instantiate and call create' do
      described_class.
        should_receive(:new).
        with(purchase_process, trading_repository).
        and_return(trading_creator_instance)

      trading_creator_instance.should_receive(:create)

      described_class.create!(purchase_process, trading_repository)
    end
  end
end

require 'unit_helper'
require 'active_support/core_ext'
require 'app/business/trading_creator'

describe TradingCreator do
  let(:trading_repository) { double(:trading_repository) }
  let(:purchase_process) { double(:purchase_process, id: 10) }

  context 'with purchase_process' do
    subject do
      described_class.new(purchase_process, trading_repository)
    end

    describe '#create' do
      context 'when allow trading auto creation' do
        before do
          purchase_process.stub(:allow_trading_auto_creation? => true)
        end

        it 'should create a new trading whit current year and purchase_process' do
          trading_repository.
            should_receive(:create).
            with(year: Date.current.year, licitation_process_id: 10).
            and_return('new trading')

          expect(subject.create).to eq 'new trading'
        end
      end

      context 'when not allow trading auto creation' do
        before do
          purchase_process.stub(:allow_trading_auto_creation? => false)
        end

        it 'should return nil' do
          trading_repository.should_not_receive(:create)

          expect(subject.create).to be_nil
        end
      end
    end
  end

  context 'without purchase_process' do
    subject do
      described_class.new(nil, trading_repository)
    end

    it 'should return nil' do
      trading_repository.should_not_receive(:create)

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

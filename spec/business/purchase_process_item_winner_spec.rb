require 'unit_helper'
require 'enumerate_it'
require 'app/enumerations/judgment_form_kind'
require 'app/business/purchase_process_item_winner'

describe PurchaseProcessItemWinner do
  let(:purchase_process) { double(:purchase_process, id: 5) }
  let(:item) { double(:item, id: 9, licitation_process: purchase_process, lot: 45) }
  let(:trading_item_repository) { double(:trading_item_repository) }
  let(:creditor_proposal_repository) { double(:creditor_proposal_repository) }

  describe '#winner' do
    subject do
      described_class.new(item, trading_item_repository: trading_item_repository,
                          creditor_proposal_repository: creditor_proposal_repository)
    end

    context 'when is a trading' do
      before do
        purchase_process.stub(trading?: true)
      end

      context 'when judgment_form_kind is lot' do
        before do
          purchase_process.stub(judgment_form_kind: JudgmentFormKind::LOT)
        end

        it 'should return the winner' do
          item1 = double(:item1, creditor_winner: 'creditor1')
          item2 = double(:item2, creditor_winner: 'creditor2')

          trading_item_repository.should_receive(:purchase_process_id).at_least(1).times.with(5).and_return trading_item_repository
          trading_item_repository.should_receive(:lot).at_least(1).times.with(45).and_return [item1, item2]

          expect(subject.winner).to eq 'creditor1'
        end
      end

      context 'when judgment_form_kind is item' do
        before do
          purchase_process.stub(judgment_form_kind: JudgmentFormKind::ITEM)
        end

        it 'should return the winner' do
          item1 = double(:item1, creditor_winner: 'creditor1')

          trading_item_repository.should_receive(:item_id).at_least(1).times.with(9).and_return [item1]

          expect(subject.winner).to eq 'creditor1'
        end
      end

      context 'when judgment_form_kind is global' do
        before do
          purchase_process.stub(judgment_form_kind: JudgmentFormKind::GLOBAL)
        end

        it 'should return nil' do
          expect(subject.winner).to be_nil
        end
      end
    end

    context 'when is not a trading' do
      let(:proposal1) { double(:proposal1, creditor: 'creditor1') }
      let(:proposal2) { double(:proposal2, creditor: 'creditor2') }

      before do
        purchase_process.stub(trading?: false)
      end

      context 'when judgment_form_kind is lot' do
        before do
          purchase_process.stub(judgment_form_kind: JudgmentFormKind::LOT)
        end

        it 'should return the winner' do
          creditor_proposal_repository.
            should_receive(:licitation_process_id).at_least(1).times.
            with(5).
            and_return creditor_proposal_repository

          creditor_proposal_repository.
            should_receive(:by_lot).at_least(1).times.
            with(45).
            and_return creditor_proposal_repository

          creditor_proposal_repository.
            should_receive(:winning_proposals).at_least(1).times.
            and_return [proposal1, proposal2]

          expect(subject.winner).to eq 'creditor1'
        end
      end

      context 'when judgment_form_kind is item' do
        before do
          purchase_process.stub(judgment_form_kind: JudgmentFormKind::ITEM)
        end

        it 'should return the winner' do
          creditor_proposal_repository.
            should_receive(:by_item_id).at_least(1).times.
            with(9).
            and_return creditor_proposal_repository

          creditor_proposal_repository.
            should_receive(:winning_proposals).at_least(1).times.
            and_return [proposal1, proposal2]

          expect(subject.winner).to eq 'creditor1'
        end
      end

      context 'when judgment_form_kind is global' do
        before do
          purchase_process.stub(judgment_form_kind: JudgmentFormKind::GLOBAL)
        end

        it 'should return the winner' do
          creditor_proposal_repository.
            should_receive(:licitation_process_id).at_least(1).times.
            with(5).
            and_return creditor_proposal_repository

          creditor_proposal_repository.
            should_receive(:winning_proposals).at_least(1).times.
            and_return [proposal1, proposal2]

          expect(subject.winner).to eq 'creditor1'
        end
      end
    end
  end

  describe '.winner' do
    it 'should instantiate and call #winner' do
      instance = double(:instance)

      described_class.
        should_receive(:new).
        with(item, trading_item_repository: trading_item_repository,
             creditor_proposal_repository: creditor_proposal_repository).
        and_return instance

        instance.should_receive(:winner).and_return 'winner'

      expect(described_class.winner(item, trading_item_repository: trading_item_repository,
                             creditor_proposal_repository: creditor_proposal_repository)).to eq 'winner'
    end
  end
end

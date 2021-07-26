require 'model_helper'
require 'app/models/realignment_price'
require 'app/models/realignment_price_item'

describe RealignmentPrice do
  it { should belong_to(:purchase_process) }
  it { should belong_to(:creditor) }

  it { should have_many :items }

  describe 'delegates' do
    it { should delegate(:judgment_form_lot?).to(:purchase_process).allowing_nil(true) }
    it { should delegate(:trading?).to(:purchase_process).allowing_nil(true) }
  end

  describe 'validations' do
    describe 'total_value_validation' do
      context 'when has items' do
        let(:item1) { double(:item1, total_price: 50) }
        let(:item2) { double(:item2, total_price: 50) }

        before do
          subject.stub(items: [item1, item2])
        end

        context "when total_value is equal the sum of items' total_price" do
          it 'should not add an error' do
            subject.stub(total_value: 100)

            subject.valid?

            expect(subject.errors[:base]).to_not include 'a soma do valor dos itens deve ser igual ao valor total da proposta/lance'
          end
        end

        context "when total_value is different the sum of items' total_price" do
          it 'should add an error' do
            subject.stub(total_value: 99)

            subject.valid?

            expect(subject.errors[:base]).to include 'a soma do valor dos itens deve ser igual ao valor total da proposta/lance'
          end
        end
      end

      context 'when has no items' do
        before do
          subject.stub(items: [])
        end

        it 'should add an error' do
          subject.stub(total_value: 99)

          subject.valid?

          expect(subject.errors[:base]).to include 'a soma do valor dos itens deve ser igual ao valor total da proposta/lance'
        end
      end
    end
  end

  describe '#purchase_process_items' do
    let(:items) { double(:items) }
    let(:purchase_process) { double(:purchase_process, items: items) }

    before do
      subject.stub(purchase_process: purchase_process)
    end

    context 'when is by lot' do
      before do
        subject.stub(judgment_form_lot?: true)
        subject.lot = 10
      end

      it 'should return the lots from purchase_process items' do
        items.should_receive(:lot).with(10).and_return([:lot1, :lot2])

        expect(subject.purchase_process_items).to eq [:lot1, :lot2]
      end
    end

    context 'when is not by lot' do
      before do
        subject.stub(judgment_form_lot?: false)
      end

      it 'should return the items from purchase_process' do
        expect(subject.purchase_process_items).to eq items
      end
    end
  end

  describe '#total_value' do
    let(:trading_items) { double(:trading_items) }
    let(:creditor_proposals) { double(:creditor_proposals) }
    let(:purchase_process) do
      double(:purchase_process, trading_items: trading_items,
             creditor_proposals: creditor_proposals)
    end

    before do
      subject.stub(purchase_process: purchase_process)
      subject.stub(creditor_id: 123)
    end

    context 'when is by lot' do
      before do
        subject.stub(judgment_form_lot?: true)
        subject.lot = 10
      end

      context 'when is a trading' do
        before do
          subject.stub(trading?: true)
        end

        it "should return the trading_item's lot total" do
          item1 = double(:item1, amount_winner: 100)
          item2 = double(:item2, amount_winner: 130)

          trading_items.should_receive(:lot).with(10).and_return [item1, item2]

          expect(subject.total_value).to eq 230
        end
      end

      context 'when is not a trading' do
        before do
          subject.stub(trading?: false)
        end

        it "should return the proposal's lot total" do
          proposal1 = double(:proposal1, unit_price: 100)
          proposal2 = double(:proposal2, unit_price: 130)

          creditor_proposals.should_receive(:creditor_id).with(123).and_return creditor_proposals
          creditor_proposals.should_receive(:by_lot).with(10).and_return [proposal1, proposal2]

          expect(subject.total_value).to eq 230
        end
      end
    end

    context 'when is not by lot(global)' do
      before do
        subject.stub(judgment_form_lot?: false)
      end

      it 'should return the sum of all proposals of the bidder' do
        proposal1 = double(:proposal1, unit_price: 100)
        proposal2 = double(:proposal2, unit_price: 130)

        creditor_proposals.should_receive(:creditor_id).with(123).and_return [proposal1, proposal2]

        expect(subject.total_value).to eq 230
      end
    end
  end
end

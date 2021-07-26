require 'model_helper'
require 'lib/signable'
require 'app/models/budget_structure'
require 'app/models/licitation_process'
require 'app/models/licitation_process_ratification'
require 'app/models/licitation_process_ratification_item'

describe LicitationProcessRatification do
  it 'should return sequence as to_s' do
    subject.stub(:sequence => 1, :licitation_process => '1/2012')
    expect(subject.to_s).to eq '1 - Processo de Compra 1/2012'
  end

  it { should belong_to :licitation_process }

  it { should have_many(:licitation_process_ratification_items).dependent(:destroy) }
  it { should have_many(:creditor_proposals).through :licitation_process }

  it { should have_one(:judgment_form).through(:licitation_process) }

  it { should validate_presence_of :licitation_process }
  it { should validate_presence_of :ratification_date }
  it { should validate_presence_of :adjudication_date }
  it { should validate_presence_of :creditor }

  it { should delegate(:process).to(:licitation_process).allowing_nil(true).prefix(true) }
  it { should delegate(:modality_humanize).to(:licitation_process).allowing_nil(true).prefix(true) }
  it { should delegate(:description).to(:licitation_process).allowing_nil(true).prefix(true) }
  it { should delegate(:licitation?).to(:licitation_process).allowing_nil(true).prefix(true) }
  it { should delegate(:trading?).to(:licitation_process).allowing_nil(true).prefix(true) }
  it { should delegate(:process_responsibles).to(:licitation_process).allowing_nil(true) }
  it { should delegate(:item?).to(:judgment_form).allowing_nil(true).prefix(true) }

  context 'creditor should belongs to licitation process' do
    let :creditor_with_licitation_process do
      double(:creditor, to_s: 'Credor Geral')
    end

    let :creditor_with_new_licitation_process do
      double(:licitation_process => double, to_s: 'Credor Geral', licitation?: true,
            judgment_commission_advice: nil)
    end

    let :licitation_process do
      double(:to_s => '1/2012',
             creditors: [creditor_with_licitation_process],
             licitation?: true,
             judgment_commission_advice: nil,
             proposal_envelope_opening_date: [])
    end

    before do
      subject.stub(:licitation_process => licitation_process)
    end

    it 'should be valid' do
      subject.stub(:creditor => creditor_with_licitation_process)

      subject.valid?

      expect(subject.errors[:creditor]).to be_empty
    end

    it 'should be invalid' do
      subject.stub(:creditor => creditor_with_new_licitation_process)

      subject.valid?

      expect(subject.errors[:creditor]).to include "Credor Geral não pertence ao processo de compra 1/2012"
    end
  end

  describe 'judgment_comisson_advice validate' do
    let(:licitation_process) do
      double(:licitation_process, to_s: '1/2013', proposal_envelope_opening_date: [])
    end

    before do
      subject.stub(licitation_process: licitation_process)
    end

    context 'when is a licitation' do
      before do
        licitation_process.stub(licitation?: true)
      end

      context 'when has no judgment_commission_advices' do
        before do
          licitation_process.stub(judgment_commission_advice: nil)
        end

        it 'should not be valid' do
          expect(subject.valid?).to be_false

          expect(subject.errors[:base]).to include('O processo de compra (1/2013) deve possuir parecer(es) da comissão de licitação')
        end
      end

      context 'when has judgment_commission_advices' do
        before do
          licitation_process.stub(judgment_commission_advice: 'advice')
        end

        it 'should not have errors on base' do
          subject.valid?

          expect(subject.errors[:base]).to_not include('O processo de compra (1/2013) deve possuir parecer(es) da comissão de licitação')
        end
      end
    end

    context 'when is not a licitation' do
      before do
        licitation_process.stub(licitation?: false)
      end

      context 'when has no judgment_commission_advices' do
        before do
          subject.stub(judgment_commission_advices: [])
        end

        it 'should not be valid' do
          subject.valid?

          expect(subject.errors[:base]).to_not include('O processo de compra (1/2013) deve possuir parecer(es) da comissão de licitação')
        end
      end
    end
  end

  describe 'validate items' do
    context 'when has no items' do
      it 'should add an error to items' do
        subject.valid?

        expect(subject.errors[:licitation_process_ratification_items]).to include('é necessário cadastrar pelo menos um item')
      end
    end

    context 'when has items' do
      let(:item) { double(:item) }

      before do
        item.stub(marked_for_destruction?: false)
        subject.stub(licitation_process_ratification_items: [item])
      end

      it 'should not add an error to items' do
        subject.valid?

        expect(subject.errors[:licitation_process_ratification_items]).to_not include('é necessário cadastrar pelo menos um item')
      end
    end
  end

  describe '#has_realignment_price?' do
    context 'when judgment_form is by item' do
      it 'should be false' do
        subject.stub judgment_form_item?: true

        expect(subject.has_realignment_price?).to be_false
      end
    end

    context 'when judgment_form is not by item' do
      it 'should be true' do
        subject.stub judgment_form_item?: false

        expect(subject.has_realignment_price?).to be_true
      end
    end
  end
end

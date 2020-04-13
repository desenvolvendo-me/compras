require 'decorator_helper'
require 'app/decorators/licitation_process_ratification_decorator'

describe LicitationProcessRatificationDecorator do
  it 'should return nil when does not have ratification_date' do
    component.stub(:ratification_date).and_return(nil)

    expect(subject.ratification_date).to eq nil
  end

  it 'should return localized ratification_date' do
    component.stub(:ratification_date).and_return(Date.new(2012, 8, 6))

    expect(subject.ratification_date).to eq "06/08/2012"
  end

  it 'should return nil when does not have adjudication_date' do
    component.stub(:adjudication_date).and_return(nil)

    expect(subject.adjudication_date).to eq nil
  end

  it 'should return localized adjudication_date' do
    component.stub(:adjudication_date).and_return(Date.new(2012, 8, 6))

    expect(subject.adjudication_date).to eq "06/08/2012"
  end

  it 'should return formated proposals_total_value' do
    component.stub(:proposals_total_value).and_return(5480.9)

    expect(subject.proposals_total_value).to eq "5.480,90"
  end

  describe '#modality_or_type_of_removal' do
    context "when licitatio process is licitation" do
      it "should return modality_humanize" do
        component.stub(:licitation_process_licitation?).and_return true
        component.stub(:licitation_process_modality_humanize).and_return 'Convite'

        expect(subject.modality_or_type_of_removal).to eq 'Convite'
      end
    end

    context "when licitatio process is direct_purchase" do
      it "should return type_of_removal_humanize" do
        component.stub(:licitation_process_licitation?).and_return false
        component.stub(:licitation_process_type_of_removal_humanize).and_return 'Dispensa por limite'

        expect(subject.modality_or_type_of_removal).to eq 'Dispensa por limite'
      end
    end
  end

  describe '#save_disabled_message' do
    before do
      I18n.backend.store_translations 'pt-BR',
        licitation_process_ratification: {
          messages: { cant_save_without_responsibles: 'cant save without responsibles' }
        }
    end

    context 'process responsibles are empty' do
      before do
        component.stub(:process_responsibles).and_return []
      end

      it 'returns a cannot save message' do
        expect(subject.save_disabled_message).to eql 'cant save without responsibles'
      end
    end

    context 'process responsibles arent empty' do
      let(:process_responsible) { double(:process_responsible) }

      before { component.stub(:process_responsibles).and_return [process_responsible] }

      it 'returns nil' do
        expect(subject.save_disabled_message).to be_nil
      end
    end
  end

  context 'with attr_header' do
    it 'should have headers' do
      expect(described_class.headers?).to be_true
    end

    it 'should have licitation_process, creditor and ratification_date' do
      expect(described_class.header_attributes).to include :licitation_process
      expect(described_class.header_attributes).to include :creditor
      expect(described_class.header_attributes).to include :ratification_date
    end
  end
end

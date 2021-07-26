require 'model_helper'
require 'app/models/budget_structure'
require 'app/models/contract'
require 'app/models/pledge'
require 'app/models/persona/person'
require 'app/models/person'
require 'app/models/persona/creditor'
require 'app/models/creditor'
require 'app/models/contract_type'
require 'app/models/licitation_process'
require 'app/models/employee'
require 'app/models/delivery_schedule'
require 'app/models/occurrence_contractual_historic'
require 'app/models/contract_termination'
require 'app/models/contract_additive'

describe Contract do
  describe 'default values' do
    it 'uses false as default for subcontracting' do
      expect(subject.subcontracting).to be false
    end
  end

  it { should belong_to :dissemination_source }
  it { should belong_to :contract_type }
  it { should belong_to :licitation_process }
  it { should belong_to :budget_structure_responsible }
  it { should belong_to :lawyer }
  it { should have_many(:delivery_schedules).dependent(:destroy).order(:sequence) }
  it { should have_many(:occurrence_contractual_historics).dependent(:restrict) }
  it { should have_many(:additives).dependent(:restrict) }
  it { should have_one(:contract_termination).dependent(:restrict) }
  it { should have_one(:creditor) }

  it 'should return contract_number as to_s method' do
    subject.contract_number = '001'
    expect(subject.to_s).to eq '001'
  end

  it { should delegate(:budget_allocations_ids).to(:licitation_process).allowing_nil(true).prefix(true) }
  it { should delegate(:modality_humanize).to(:licitation_process).allowing_nil(true).prefix(true) }
  it { should delegate(:type_of_removal_humanize).to(:licitation_process).allowing_nil(true).prefix(true) }

  it { should validate_presence_of :year }
  it { should validate_presence_of :contract_number }
  it { should validate_presence_of :publication_date }
  it { should validate_presence_of :dissemination_source }
  it { should validate_presence_of :content }
  it { should validate_presence_of :creditor_id }
  it { should validate_presence_of :contract_value }
  it { should validate_presence_of :contract_validity }
  it { should validate_presence_of :signature_date }
  it { should validate_presence_of :start_date }
  it { should validate_presence_of :end_date }
  it { should validate_presence_of :budget_structure_responsible }
  it { should validate_presence_of :contract_type }
  it { should validate_presence_of :penalty_fine }
  it { should validate_presence_of :default_fine }

  it { should allow_value('2012').for(:year) }
  it { should_not allow_value('201a').for(:year) }

  context 'validating date' do
    before do
      subject.stub(:signature_date).and_return(Date.new(2012, 2, 1))
    end

    it 'be valid when the end_date is after signature_date' do
      expect(subject).to allow_value(Date.new(2012, 2, 10)).for(:end_date)
    end

    it 'be invalid when the signature_date is after end_date' do
      expect(subject).not_to allow_value(Date.new(2012, 1, 1)).for(:end_date).
                                                           with_message('deve ser depois da data de assinatura (01/02/2012)')
    end

    it 'be invalid when the end_date is equal to signature' do
      expect(subject).not_to allow_value(Date.new(2012, 2, 1)).for(:end_date).
                                                           with_message('deve ser depois da data de assinatura (01/02/2012)')
    end
  end

  describe '#modality_humanize' do
    context 'given a licitation process' do
      let(:modality) { double(:modality) }

      let(:direct_purchase?) { false }

      let :licitation_process do
        double('LicitationProcess', modality_humanize: modality, direct_purchase?: direct_purchase?)
      end

      before do
        subject.stub(:licitation_process).and_return licitation_process
      end

      it 'should return the licitation process modality' do
        expect(subject.modality_humanize).to eq modality
      end
    end

    context 'given a type_of_removal' do
      let(:direct_purchase?) { true }

      let :licitation_process do
        double('LicitationProcess', type_of_removal_humanize: 'xxto', direct_purchase?: direct_purchase?)
      end

      before do
        subject.stub(:licitation_process).and_return licitation_process
      end

      it 'should return the direct purchase modality' do
        expect(subject.modality_humanize).to eq 'xxto'
      end
    end
  end

  context 'pledges list and pledges sum' do
    let :pledge_1 do
      double('Pledge', :id => 1)
    end

    let :pledge_2 do
      double('Pledge', :id => 2)
    end

    it 'should return pledges and founded debt pledges on all_pledges' do
      subject.stub(:pledges => [pledge_1])
      subject.stub(:founded_debt_pledges => [pledge_2])

      expect(subject.all_pledges.size).to eq 2
    end

    it 'should return pledges as a uniq list' do
      subject.stub(:pledges => [pledge_1])
      subject.stub(:founded_debt_pledges => [pledge_1])

      expect(subject.all_pledges.size).to eq 1
    end

    it 'should return pledges total value with founded debt pledges on all_pledges_total_value' do
      subject.stub(:all_pledges => [double(:amount => 100), double(:amount => 50)])

      expect(subject.all_pledges_total_value).to eq 150
    end
  end

  describe '#allow_termination?' do
    it 'should return false when contract_termination is present' do
      contract_termination = double(:contract_termination)

      subject.stub(:contract_termination).and_return(contract_termination)

      expect(subject.allow_termination?).to be_false
    end
  end
end

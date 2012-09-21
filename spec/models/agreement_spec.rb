require 'model_helper'
require 'app/uploaders/document_uploader'
require 'app/models/agreement_occurrence'
require 'app/models/agreement_participant'
require 'app/models/agreement'
require 'app/models/agreement_bank_account'
require 'app/models/bank_account_capability'
require 'app/models/bank_account'
require 'app/models/agreement_additive'
require 'app/models/tce_capability_agreement'

describe Agreement do
  it 'should return description as to_s' do
    subject.description = 'Apoio ao fomento do turismo'
    expect(subject.to_s).to eq 'Apoio ao fomento do turismo'
  end

  it { should belong_to :agreement_kind }
  it { should belong_to :regulatory_act }

  it { should have_many(:agreement_bank_accounts).dependent(:destroy) }
  it { should have_many(:tce_specification_capabilities).dependent(:restrict).through(:tce_capability_agreements) }
  it { should have_many(:tce_capability_agreements).dependent(:restrict) }
  it { should have_many(:agreement_occurrences).dependent(:destroy) }
  it { should have_many(:agreement_additives).dependent(:destroy).order(:number) }
  it { should have_many(:agreement_participants).dependent(:destroy).order(:id) }

  it { should validate_presence_of :number_year }
  it { should validate_presence_of :category }
  it { should validate_presence_of :agreement_kind }
  it { should validate_presence_of :value }
  it { should validate_presence_of :counterpart_value }
  it { should validate_presence_of :parcels_number }
  it { should validate_presence_of :description }
  it { should validate_presence_of :process_date }
  it { should validate_presence_of :number_year_process }
  it { should validate_presence_of :regulatory_act }
  it { should validate_duplication_of(:bank_account_id).on(:agreement_bank_accounts) }


  it { should allow_value('111/2012').for(:number_year) }
  it { should_not allow_value('111').for(:number_year) }
  it { should_not allow_value('1a1/2012').for(:number_year) }

  it { should allow_value('111/2012').for(:number_year_process) }
  it { should_not allow_value('111').for(:number_year_process) }
  it { should_not allow_value('1a1/2012').for(:number_year_process) }

  context 'delegate to regulatory_act' do
    before do
      subject.stub(:regulatory_act).and_return(regulatory_act)
    end

    let :regulatory_act do
      double('RegulatoryAct',
             :creation_date => Date.new(2012, 12, 29),
             :publication_date => Date.new(2012, 12, 30),
             :end_date => Date.new(2012, 12, 31)
            )
    end

    it "creation_date" do
      expect(subject.creation_date).to eq Date.new(2012, 12, 29)
    end

    it "publication_date" do
      expect(subject.publication_date).to eq Date.new(2012, 12, 30)
    end

    it "end_date" do
      expect(subject.end_date).to eq Date.new(2012, 12, 31)
    end
  end

  context 'last additive number' do
    before do
      subject.stub(:agreement_additives).and_return(additives)
    end

    context 'when dont have additives' do
      let :additives do
        []
      end

      it 'should return last additive number' do
        expect(subject.last_additive_number).to eq 0
      end
    end

    context 'when have one additive' do
      let :additives do
        [ double('Additive', :number => 2, :persisted? => true) ]
      end

      it 'should return last additive number' do
        expect(subject.last_additive_number).to eq 2
      end
    end
  end

  context '#persisted_and_has_occurrences?' do
    it 'should return true when is persisted and agreement_occurrences is present' do
      subject.stub(:persisted? => true, :agreement_occurrences => [double])

      expect(subject.persisted_and_has_occurrences?).to be true
    end

    it 'should return false when is not persisted' do
      subject.stub(:persisted? => false, :agreement_occurrences => [double])

      expect(subject.persisted_and_has_occurrences?).to be false
    end

    it 'should return false when agreement_occurrences is empty' do
      subject.stub(:persisted? => true, :agreement_occurrences => [])

      expect(subject.persisted_and_has_occurrences?).to be false
    end
  end

  describe 'validating participants' do
    let :participants_grantings do
      [double(:granting? => true, :convenente? => false, :value => 200, :marked_for_destruction? => false),
       double(:granting? => true, :convenente? => false, :value => 100, :marked_for_destruction? => false)]
    end

    let :participants_convenentes do
      [double(:granting? => false, :convenente? => true, :value => 300, :marked_for_destruction? => false),
       double(:granting? => false, :convenente? => true, :value => 400, :marked_for_destruction? => false)]
    end

    context 'validates if sum of value of participants grantings is equals value + counterpart_value' do
      before do
        subject.stub(:agreement_participants => participants_grantings,
                     :if_sum_of_participants_convenente_equals_total_value => true)
      end

      it 'should be valid' do
        subject.stub(:value => 250, :counterpart_value => 50)

        subject.valid?

        expect(subject.errors[:agreement_participants]).to be_empty
      end

      it 'should be invalid' do
        subject.stub(:value => 50, :counterpart_value => 60)

        subject.valid?

        expect(subject.errors[:agreement_participants]).to include 'a soma do valor dos participantes concedentes deve ser igual a R$ 110,00'
      end
    end

    context 'validates if sum of value of participants convenentes is equals value + counterpart_value' do
      before do
        subject.stub(:agreement_participants => participants_convenentes,
                     :if_sum_of_participants_granting_equals_total_value => true)
      end

      it 'should be valid' do
        subject.stub(:value => 500, :counterpart_value => 200)

        subject.valid?

        expect(subject.errors[:agreement_participants]).to be_empty
      end

      it 'should be invalid' do
        subject.stub(:value => 100, :counterpart_value => 100)

        subject.valid?

        expect(subject.errors[:agreement_participants]).to include 'a soma do valor dos participantes convenentes deve ser igual a R$ 200,00'
      end
    end
  end
end

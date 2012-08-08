#encoding: utf-8
require 'model_helper'
require 'app/models/precatory'
require 'app/models/creditor'
require 'app/models/precatory_type'
require 'app/models/precatory_parcel'

describe Precatory do
  it { should validate_presence_of :number }
  it { should validate_presence_of :creditor }
  it { should validate_presence_of :date }
  it { should validate_presence_of :judgment_date }
  it { should validate_presence_of :apresentation_date }
  it { should validate_presence_of :precatory_type }
  it { should validate_presence_of :historic }
  it { should validate_presence_of :value }

  it { should belong_to :creditor }
  it { should belong_to :precatory_type }
  it { should have_many(:precatory_parcels).dependent(:destroy).order(:id) }

  it "should return id when call to_s method" do
    subject.number = '1234/2012'

    expect(subject.to_s).to eq "1234/2012"
  end

  context "parceled_value" do
    let :precatory_parcels do
      [
        double('parcel1', :value => 1000.0),
        double('parcel2', :value => 2000.0)
      ]
    end

    it "should be the sum of all parcel values" do
      subject.stub(:precatory_parcels => precatory_parcels)

      expect(subject.parceled_value).to eq 3000.0
    end
  end

  it "should not allow parceled_value different from value" do
    subject.value = 4000.0
    subject.stub(:parceled_value => 3000.0)

    subject.valid?
    expect(subject.errors[:parceled_value]).to include "deve ser igual ao valor do precatório (R$ 4.000,00)"
  end

  it "should allow parceled_value equals value" do
    subject.value = 4000.0
    subject.stub(:parceled_value => 4000.0)

    subject.valid?
    expect(subject.errors[:parceled_value]).not_to include "deve ser igual ao valor do precatório (R$ 4.000,00)"
  end
end

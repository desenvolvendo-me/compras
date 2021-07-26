require 'model_helper'
require 'app/models/modality_limit'

describe ModalityLimit do
  it 'should return ordinance_number as to_s' do
    subject.id = 9999
    expect(subject.to_s).to eq '9999'
  end

  it { should validate_presence_of :without_bidding }
  it { should validate_presence_of :invitation_letter }
  it { should validate_presence_of :taken_price }
  it { should validate_presence_of :public_competition }
  it { should validate_presence_of :work_without_bidding }
  it { should validate_presence_of :work_invitation_letter }
  it { should validate_presence_of :work_taken_price }
  it { should validate_presence_of :work_public_competition }

  context "limits of current" do
    it 'should return correctly the value for current_limit_material_or_service_without_bidding' do
      ModalityLimit.stub(:current).and_return(double(:without_bidding => 200.0))

      expect(ModalityLimit.current_limit_material_or_service_without_bidding).to eq 200.0
    end

    it 'should return correctly the value for current_limit_engineering_works_without_bidding' do
      ModalityLimit.stub(:current).and_return(double(:work_without_bidding => 300.0))

      expect(ModalityLimit.current_limit_engineering_works_without_bidding).to eq 300.0
    end

    it 'should return zero for current_limits when there is no current modality limit' do
      ModalityLimit.stub(:current).and_return(nil)

      expect(ModalityLimit.current_limit_material_or_service_without_bidding).to eq 0
      expect(ModalityLimit.current_limit_engineering_works_without_bidding).to eq 0
    end
  end
end

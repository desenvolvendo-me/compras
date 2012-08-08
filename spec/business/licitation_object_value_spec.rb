require 'unit_helper'
require 'app/business/licitation_object_value'

describe LicitationObjectValue do
  let(:object) do
    double(:purchase_licitation_exemption => 10,
           :purchase_invitation_letter    => 20,
           :purchase_taking_price         => 30,
           :purchase_public_concurrency   => 40,
           :build_licitation_exemption    => 50,
           :build_invitation_letter       => 60,
           :build_taking_price            => 70,
           :build_public_concurrency      => 80,
           :special_auction               => 90,
           :special_unenforceability      => 100,
           :special_contest               => 110)
  end

  it 'should return limits for modality purchase' do
    expect(LicitationObjectValue.new(object, :modality => :purchase, :limit => :licitation_exemption).value).to eq 10
    expect(LicitationObjectValue.new(object, :modality => :purchase, :limit => :invitation_letter).value).to eq 20
    expect(LicitationObjectValue.new(object, :modality => :purchase, :limit => :taking_price).value).to eq 30
    expect(LicitationObjectValue.new(object, :modality => :purchase, :limit => :public_concurrency).value).to eq 40
  end

  it 'should return limits for modality build' do
    expect(LicitationObjectValue.new(object, :modality => :build, :limit => :licitation_exemption).value).to eq 50
    expect(LicitationObjectValue.new(object, :modality => :build, :limit => :invitation_letter).value).to eq 60
    expect(LicitationObjectValue.new(object, :modality => :build, :limit => :taking_price).value).to eq 70
    expect(LicitationObjectValue.new(object, :modality => :build, :limit => :public_concurrency).value).to eq 80
  end

  it 'should return limits for modality special' do
    expect(LicitationObjectValue.new(object, :modality => :special, :limit => :auction).value).to eq 90
    expect(LicitationObjectValue.new(object, :modality => :special, :limit => :unenforceability).value).to eq 100
    expect(LicitationObjectValue.new(object, :modality => :special, :limit => :contest).value).to eq 110
  end
end

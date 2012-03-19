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
    LicitationObjectValue.new(object, :modality => :purchase, :limit => :licitation_exemption).value.should eq 10
    LicitationObjectValue.new(object, :modality => :purchase, :limit => :invitation_letter).value.should eq 20
    LicitationObjectValue.new(object, :modality => :purchase, :limit => :taking_price).value.should eq 30
    LicitationObjectValue.new(object, :modality => :purchase, :limit => :public_concurrency).value.should eq 40
  end

  it 'should return limits for modality build' do
    LicitationObjectValue.new(object, :modality => :build, :limit => :licitation_exemption).value.should eq 50
    LicitationObjectValue.new(object, :modality => :build, :limit => :invitation_letter).value.should eq 60
    LicitationObjectValue.new(object, :modality => :build, :limit => :taking_price).value.should eq 70
    LicitationObjectValue.new(object, :modality => :build, :limit => :public_concurrency).value.should eq 80
  end

  it 'should return limits for modality special' do
    LicitationObjectValue.new(object, :modality => :special, :limit => :auction).value.should eq 90
    LicitationObjectValue.new(object, :modality => :special, :limit => :unenforceability).value.should eq 100
    LicitationObjectValue.new(object, :modality => :special, :limit => :contest).value.should eq 110
  end
end

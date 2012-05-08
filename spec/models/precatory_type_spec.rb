#encoding: utf-8
require 'model_helper'
require 'app/models/precatory_type'

describe PrecatoryType do
  it { should validate_presence_of :description }
  it { should validate_presence_of :status }

  it "should validate presence of deactivation_date when status is inactive" do
    subject.status = PrecatoryTypeStatus::INACTIVE

    subject.should_not allow_value(nil).for(:deactivation_date).
                                        with_message('não pode ficar em branco')
  end

  it "should return id as to_s" do
    subject.id = 1

    subject.to_s.should eq '1'
  end

  it "should not validate presence of deactivation_date when status is active" do
    subject.status = PrecatoryTypeStatus::ACTIVE

    subject.should allow_value(nil).for(:deactivation_date)
  end

  it "should clean deactivation_date when status is active" do
    subject.status = PrecatoryTypeStatus::ACTIVE
    subject.description = 'description'
    subject.deactivation_date = Date.current

    subject.save!
    subject.deactivation_date.should be_nil
  end
end

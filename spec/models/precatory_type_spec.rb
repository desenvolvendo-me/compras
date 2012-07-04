#encoding: utf-8
require 'model_helper'
require 'app/models/precatory_type'
require 'app/models/precatory'

describe PrecatoryType do
  it { should validate_presence_of :description }
  it { should validate_presence_of :status }

  it { should have_many(:precatories).dependent(:restrict) }

  it "should return id as to_s" do
    subject.description = 'Alimentares'

    subject.to_s.should eq 'Alimentares'
  end

  context 'validate deactivation_date related with today' do
    it { should allow_value(Date.current).for(:deactivation_date) }

    it { should allow_value(Date.yesterday).for(:deactivation_date) }

    it 'should not allow date after today' do
      subject.should_not allow_value(Date.tomorrow).for(:deactivation_date).
                                                    with_message("deve ser igual ou anterior a hoje (#{I18n.l(Date.current)})")
    end
  end

  context "with active status" do
    before do
      subject.status = PrecatoryTypeStatus::ACTIVE
    end

    it 'should not validate presence of deactivation_date' do
      subject.should_not validate_presence_of :deactivation_date
    end

    it "should clean deactivation_date when status is active" do
      subject.description = 'description'
      subject.deactivation_date = Date.current

      subject.run_callbacks(:save)
      subject.deactivation_date.should be_nil
    end
  end

  context "with inactive status" do
    before do
      subject.status = PrecatoryTypeStatus::INACTIVE
    end

    it 'should validate presence of deactivation_date' do
      subject.should validate_presence_of :deactivation_date
    end
  end
end

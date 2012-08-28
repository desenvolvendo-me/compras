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

    expect(subject.to_s).to eq 'Alimentares'
  end

  context 'validate deactivation_date related with today' do
    it { should allow_value(Date.current).for(:deactivation_date) }

    it { should allow_value(Date.yesterday).for(:deactivation_date) }

    it 'should not allow date after today' do
      expect(subject).not_to allow_value(Date.tomorrow).for(:deactivation_date).
                                                    with_message("deve ser igual ou anterior a data atual (#{I18n.l(Date.current)})")
    end
  end

  context "with active status" do
    before do
      subject.status = Status::ACTIVE
    end

    it 'should not validate presence of deactivation_date' do
      expect(subject).not_to validate_presence_of :deactivation_date
    end

    it "should clean deactivation_date when status is active" do
      subject.description = 'description'
      subject.deactivation_date = Date.current

      subject.run_callbacks(:save)
      expect(subject.deactivation_date).to be_nil
    end
  end

  context "with inactive status" do
    before do
      subject.status = Status::INACTIVE
    end

    it 'should validate presence of deactivation_date' do
      expect(subject).to validate_presence_of :deactivation_date
    end
  end
end

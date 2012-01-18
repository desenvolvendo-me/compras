# encoding: utf-8
require 'model_helper'
require 'app/models/working_hour'
require 'active_support/core_ext/numeric'

describe WorkingHour do
  let(:subject) { WorkingHour.new }

  it { should validate_presence_of :initial }
  it { should validate_presence_of :final }

  it 'return name when converted to string' do
    subject.name = 'Normal'
    subject.name.should eq subject.to_s
  end

  describe 'validate intervals' do
    it "initial before beginning_interval" do
      subject.beginning_interval = Time.now
      subject.initial = 10.minutes.from_now
      subject.should_not be_valid
      subject.errors[:initial].should_not be_empty
    end
    it "beginning_interval after initial" do
      subject.initial = Time.now
      subject.beginning_interval = 10.minutes.ago
      subject.should_not be_valid
      subject.errors[:beginning_interval].should_not be_empty
    end

    it "end_of_interval after beginning_interval" do
      subject.beginning_interval = Time.now
      subject.end_of_interval = 10.minutes.ago
      subject.should_not be_valid
      subject.errors[:end_of_interval].should_not be_empty
    end

    it "final after end_of_interval" do
      subject.end_of_interval = Time.now
      subject.final = 10.minutes.ago
      subject.should_not be_valid
      subject.errors[:final].should_not be_empty
    end

    it "should required beginning_interval only when end_of_interval is present" do
      subject.valid?
      subject.errors[:beginning_interval].should_not include 'não pode ficar em branco'

      subject.end_of_interval = Time.now
      subject.should_not be_valid
      subject.errors[:beginning_interval].should include 'não pode ficar em branco'
    end

    it "should required end_of_interval only when beginning_interval is present" do
      subject.valid?
      subject.errors[:end_of_interval].should_not include 'não pode ficar em branco'

      subject.beginning_interval = Time.now
      subject.should_not be_valid
      subject.errors[:end_of_interval].should include 'não pode ficar em branco'
    end
  end

  it { should validate_presence_of :name }
  it { should validate_presence_of :initial }
  it { should validate_presence_of :final }

end

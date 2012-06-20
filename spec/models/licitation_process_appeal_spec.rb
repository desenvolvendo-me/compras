# encoding: utf-8
require 'model_helper'
require 'app/models/unico/person'
require 'app/models/person'
require 'app/models/licitation_process'
require 'app/models/licitation_process_appeal'

describe LicitationProcessAppeal do

  it 'should return id as to_s method' do
    subject.id = 2

    subject.to_s.should eq '2'
  end

  it { should belong_to :person }
  it { should belong_to :licitation_process }

  it { should validate_presence_of :person }
  it { should validate_presence_of :licitation_process }
  it { should validate_presence_of :appeal_date }

  context "validating appeal_date" do
    context "should be equal or greater than process_date" do
      let(:licitation_process) do
        double('licitation_process', :id => 1, :process_date => Date.current)
      end

      it 'should not be valid' do
        subject.stub(:appeal_date => Date.yesterday, :licitation_process => licitation_process)
        subject.should_not be_valid
        subject.errors[:appeal_date].should include "deve ser maior ou igual a data do processo"
      end
    end
  end
end

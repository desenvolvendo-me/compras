# encoding: utf-8
require 'model_helper'
require 'app/models/employee'
require 'app/models/administrative_process'
require 'app/models/administrative_process_liberation'

describe AdministrativeProcessLiberation do
  it { should belong_to :administrative_process }
  it { should belong_to :employee }

  it { should validate_presence_of :administrative_process }
  it { should validate_presence_of :employee }
  it { should validate_presence_of :date }

  context "with employee" do
    let :employee do
      double(:employe)
    end

    it "should return employee - date" do
      employee.stub(:to_s => 'João')
      subject.stub(:employee => employee)
      subject.date = Date.new(2012, 06, 10)

      subject.to_s.should eq 'João - 10/06/2012'
    end
  end
end

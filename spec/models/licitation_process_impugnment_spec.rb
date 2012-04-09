# encoding: utf-8
require 'model_helper'
require 'app/models/licitation_process_impugnment'
require 'app/models/licitation_process'

describe LicitationProcessImpugnment do

  it { should belong_to :licitation_process }
  it { should belong_to :person }
  it { should validate_presence_of :licitation_process }
  it { should validate_presence_of :impugnment_date }
  it { should validate_presence_of :related }
  it { should validate_presence_of :person }
  it { should validate_presence_of :situation }
  
  it "should not have impugnment_date less than process_date" do
    licitation_process = double('licitation_process', :id => 1, :process_date => Date.current)
    licitation_process_impugnment = double(
                                      'licitation_process_impugnment', 
                                      :impugnment_date => Date.yesterday, 
                                      :licitation_process => licitation_process
                                    )

    subject.stub(:licitation_process_impugnment => licitation_process_impugnment)

    subject.valid?
    subject.errors[:impugnment_date].should include "deve ser maior ou igual a data do processo"
  end

  it "should not have judgment_date less than impugnment_date" do
    licitation_process = double('licitation_process', :id => 1, :process_date => Date.current)
    licitation_process_impugnment = double(
                                      'licitation_process_impugnment',
                                      :impugnment_date => Date.yesterday,
                                      :judgment_date => Date.yesterday - 1.day,
                                      :licitation_process => licitation_process
                                    )

    subject.stub(:licitation_process_impugnment => licitation_process_impugnment)

    subject.valid?
    subject.errors[:judgment_date].should include "deve ser maior ou igual a data da impugnação"
  end
end
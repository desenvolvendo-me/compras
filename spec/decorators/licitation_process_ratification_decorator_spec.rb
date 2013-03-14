# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/licitation_process_ratification_decorator'

describe LicitationProcessRatificationDecorator do
  it 'should return nil when does not have ratification_date' do
    component.stub(:ratification_date).and_return(nil)

    expect(subject.ratification_date).to eq nil
  end

  it 'should return localized ratification_date' do
    component.stub(:ratification_date).and_return(Date.new(2012, 8, 6))

    expect(subject.ratification_date).to eq "06/08/2012"
  end

  it 'should return nil when does not have adjudication_date' do
    component.stub(:adjudication_date).and_return(nil)

    expect(subject.adjudication_date).to eq nil
  end

  it 'should return localized adjudication_date' do
    component.stub(:adjudication_date).and_return(Date.new(2012, 8, 6))

    expect(subject.adjudication_date).to eq "06/08/2012"
  end

  it 'should return formated proposals_total_value' do
    component.stub(:proposals_total_value).and_return(5480.9)

    expect(subject.proposals_total_value).to eq "5.480,90"
  end
end

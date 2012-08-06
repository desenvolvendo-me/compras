# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/licitation_process_ratification_decorator'

describe LicitationProcessRatificationDecorator do
  it 'should return nil when does not have ratification_date' do
    component.stub(:ratification_date).and_return(nil)

    subject.ratification_date.should eq nil
  end

  it 'should return localized ratification_date' do
    component.stub(:ratification_date).and_return(Date.new(2012, 8, 6))

    subject.ratification_date.should eq "06/08/2012"
  end

  it 'should return nil when does not have adjudication_date' do
    component.stub(:adjudication_date).and_return(nil)

    subject.adjudication_date.should eq nil
  end

  it 'should return localized adjudication_date' do
    component.stub(:adjudication_date).and_return(Date.new(2012, 8, 6))

    subject.adjudication_date.should eq "06/08/2012"
  end

  it 'should return formated proposals_total_value' do
    component.stub(:proposals_total_value).and_return(5480.9)

    subject.proposals_total_value.should eq "5.480,90"
  end

  context 'with proposals' do
    let :proposal1 do
      double(:proposta1, :budget_allocation => 'Alocação 1')
    end

    let :proposal2 do
      double(:proposta2, :budget_allocation => 'Alocação 1')
    end

    let :proposal3 do
      double(:proposta2, :budget_allocation => 'Alocação 3')
    end

    let :proposals do
      [
        proposal1,
        proposal2,
        proposal3
      ]
    end

    it 'should return unique budget_allocations' do
      component.stub(:licitation_process_bidder_proposals).and_return(proposals)

      subject.budget_allocations.should eq 'Alocação 1, Alocação 3'
    end
  end
end

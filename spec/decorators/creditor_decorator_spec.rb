# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/creditor_decorator'

describe CreditorDecorator do
  let :date do
    Date.new(2012, 12, 14)
  end

  it 'should return commercial_registration_date' do
    component.stub(:commercial_registration_date).and_return(date)
    helpers.stub(:l).with(date).and_return('14/12/2012')

    subject.commercial_registration_date.should eq '14/12/2012'
  end
end

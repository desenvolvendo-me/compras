# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/creditor_decorator'

describe CreditorDecorator do
  let :date do
    Date.new(2142, 12, 14)
  end

  it 'should return commercial_registration_date' do
    component.stub(:commercial_registration_date).and_return(date)
    helpers.stub(:l).with(date).and_return('14/12/2142')

    subject.commercial_registration_date.should eq '14/12/2142'
  end
end

# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/creditor_decorator'

describe CreditorDecorator do
  context '#commercial_registration_date' do
    before do
      component.stub(:commercial_registration_date).and_return(date)
    end

    let :date do
      Date.new(2012, 12, 14)
    end

    it 'should localize' do
      subject.commercial_registration_date.should eq '14/12/2012'
    end
  end
end

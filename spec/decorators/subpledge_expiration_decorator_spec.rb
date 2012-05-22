require 'decorator_helper'
require 'app/decorators/subpledge_expiration_decorator'

describe SubpledgeExpirationDecorator do
  it 'should return formatted balance' do
    component.stub(:balance).and_return(9.99)
    helpers.stub(:number_to_currency).with(9.99).and_return('R$ 9,99')

    subject.balance.should eq 'R$ 9,99'
  end

  it 'should return canceled_value' do
    component.stub(:balance).and_return(100.0)
    helpers.stub(:number_to_currency).with(100.0).and_return('R$ 100,00')

    subject.balance.should eq 'R$ 100,00'
  end

  it 'should return value' do
    component.stub(:value).and_return(100.0)
    helpers.stub(:number_to_currency).with(100.0).and_return('R$ 100,00')

    subject.value.should eq 'R$ 100,00'
  end
end

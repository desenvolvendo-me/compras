require 'decorator_helper'
require 'app/decorators/subpledge_expiration_decorator'

describe SubpledgeExpirationDecorator do
  it 'should return formatted balance' do
    component.stub(:balance).and_return(9.99)
    helpers.stub(:number_with_precision).with(9.99).and_return('9,99')

    subject.balance.should eq '9,99'
  end
end

require 'decorator_helper'
require 'app/decorators/licitation_commission_decorator'

describe LicitationCommissionDecorator do

  it 'should return formatted regulatory_act_publication_date' do
    component.stub(:regulatory_act_publication_date).and_return(Date.new(2012, 2, 16))
    helpers.stub(:l).with(Date.new(2012, 2, 16)).and_return('16/02/2012')

    subject.regulatory_act_publication_date.should eq '16/02/2012'
  end
end

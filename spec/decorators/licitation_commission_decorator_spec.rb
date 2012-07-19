require 'decorator_helper'
require 'app/decorators/licitation_commission_decorator'

describe LicitationCommissionDecorator do
  context '#regulatory_act_publication_date' do
    before do
      component.stub(:regulatory_act_publication_date).and_return(date)
      helpers.stub(:l).with(date).and_return('16/02/2012')
    end

    let :date do
      Date.new(2012, 2, 16)
    end

    it 'should localize' do
      subject.regulatory_act_publication_date.should eq '16/02/2012'
    end
  end
end

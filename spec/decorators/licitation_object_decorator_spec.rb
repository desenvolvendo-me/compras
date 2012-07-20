# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/licitation_object_decorator'

describe LicitationObjectDecorator do
  context '#purchase_licitation_exemption_with_precision' do
    before do
      component.stub(:purchase_licitation_exemption).and_return(500.0)
    end

    it 'should applies precision' do
      subject.purchase_licitation_exemption_with_precision.should eq '500,00'
    end
  end

  context '#build_licitation_exemption_with_precision' do
    before do
      component.stub(:build_licitation_exemption).and_return(300.0)
    end

    it 'should applies precision' do
      subject.build_licitation_exemption_with_precision.should eq '300,00'
    end
  end
end

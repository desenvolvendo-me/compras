# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/subfunction_decorator'

describe SubfunctionDecorator do
  it 'should return function as summary' do
    component.stub(:function).and_return(double(:to_s => 'Administração'))
    subject.summary.should eq 'Administração'
  end
end

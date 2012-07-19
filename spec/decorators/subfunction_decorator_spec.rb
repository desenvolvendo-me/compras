# encoding: utf-8
require 'decorator_helper'
require 'app/decorators/subfunction_decorator'

describe SubfunctionDecorator do
  context '#summary' do
    before do
      component.stub(:function).and_return(function)
    end

    let :function do
      double(:to_s => 'Administração')
    end

    it 'should return function as summary' do
      subject.summary.should eq 'Administração'
    end
  end
end

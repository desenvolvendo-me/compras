require 'presenter_helper'

describe Presenter::Proxy do
  subject do
    presenter.new(object)
  end

  let :presenter do
    Class.new(Presenter::Proxy)
  end

  let :object do
    double
  end

  it 'delegates everything to object' do
    object.stub(:name).and_return('Gabriel Sobrinho')

    subject.should respond_to :name
    subject.name.should eq 'Gabriel Sobrinho'
  end
end

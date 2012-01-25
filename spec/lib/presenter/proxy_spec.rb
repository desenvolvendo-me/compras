require 'presenter_helper'

describe Presenter::Proxy do
  subject do
    presenter.new(object, routes)
  end

  let :presenter do
    Class.new(Presenter::Proxy) do
      def path
        routes.person_path(object)
      end
    end
  end

  let :object do
    double
  end

  let :routes do
    double
  end

  it 'delegates everything to object' do
    object.stub(:name).and_return('Gabriel Sobrinho')

    subject.should respond_to :name
    subject.name.should eq 'Gabriel Sobrinho'
  end

  it 'could use routes' do
    routes.stub(:person_path).with(object).and_return('/people/1')

    subject.path.should eq '/people/1'
  end
end

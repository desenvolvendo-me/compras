require 'decorator_helper'

describe Decorator do
  subject do
    decorator.new(component, routes, helpers)
  end

  let :decorator do
    Class.new(Decorator) do
      attr_modal :my, :attributes

      def path
        routes.person_path(component)
      end

      def balance
        helpers.number_to_currency(component)
      end
    end
  end

  let :component do
    double :component, :decorator_class => decorator_class
  end

  let :routes do
    double :routes
  end

  let :helpers do
    double :helpers
  end

  let :decorator_class do
    double :decorator_class
  end

  it 'delegates everything to component' do
    component.stub(:name).and_return('Gabriel Sobrinho')

    subject.should respond_to :name
    subject.name.should eq 'Gabriel Sobrinho'
  end

  it 'could use routes' do
    routes.stub(:person_path).with(component).and_return('/people/1')

    subject.path.should eq '/people/1'
  end

  it 'could use helpers' do
    helpers.stub(:number_to_currency).with(component).and_return('$100.00')

    subject.balance.should eq '$100.00'
  end

  it 'should return an list with modal attributes' do
    String.any_instance.stub(:constantize).and_return(decorator_class)
    decorator_class.stub(:modal_attributes).and_return(['my', 'attributes'])

    subject.modal_attributes.to_a.should eq ['my', 'attributes']
  end

  it 'should return only the component when has not the localized method' do
    component.stub(:date => Date.new(2012, 5, 18))

    subject.date.should eq Date.new(2012, 5, 18)
  end

  it 'should return the original component equal to not localized component' do
    subject.original_component.should eq component
  end

  context 'when the component has localized method' do
    before do
      component.should_receive(:localized).and_return(localized_component)
    end

    let :localized_component do
      double('localized_component', :date => "18/05/2012")
    end

    it 'should return localized component' do
      component.stub(:date => Date.new(2012, 5, 18))

      subject.date.should eq "18/05/2012"
    end

    it 'should return the original component equal to not localized component' do
      subject.original_component.should eq component
    end
  end
end

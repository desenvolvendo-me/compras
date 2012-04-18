require 'presenter_helper'

describe Presenter::Proxy do
  subject do
    presenter.new(object, routes, helpers)
  end

  let :presenter do
    Class.new(Presenter::Proxy) do
      attr_modal :my, :attributes
      attr_data 'value' => :id, 'my-first-name' => :first_name

      def path
        routes.person_path(object)
      end

      def balance
        helpers.number_to_currency(object)
      end
    end
  end

  let :object do
    double
  end

  let :routes do
    double
  end

  let :helpers do
    double
  end

  let :presenter_class do
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

  it 'could use helpers' do
    helpers.stub(:number_to_currency).with(object).and_return('$100.00')

    subject.balance.should eq '$100.00'
  end

  it 'should return an list with modal attributes' do
    String.any_instance.stub(:constantize).and_return(presenter_class)
    presenter_class.stub(:modal_attributes).and_return(['my', 'attributes'])

    subject.modal_attributes.to_a.should eq ['my', 'attributes']
  end

  it 'should return an list with data attributes' do
    String.any_instance.stub(:constantize).and_return(presenter_class)
    presenter_class.stub(:data_attributes).and_return({:attribute => 'value'})

    subject.data_attributes.should eq ({:attribute => 'value'})
  end

  it 'should return an list with data attributes and default data attributes' do
    String.any_instance.stub(:constantize).and_return(presenter)

    attributes = Set.new({:value => 'id', :label => 'to_s', :type => 'class', 'value' => :id, 'my-first-name' => :first_name})

    subject.data_attributes.should eq attributes
  end
end

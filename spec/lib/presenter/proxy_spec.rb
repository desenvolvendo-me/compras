require 'presenter_helper'

describe Presenter::Proxy do
  subject do
    presenter.new(object, routes, helpers)
  end

  let :presenter do
    Class.new(Presenter::Proxy) do
      attr_modal :my, :attributes
      attr_data 'my-first-name' => :first_name

      def path
        routes.person_path(object)
      end

      def balance
        helpers.number_to_currency(object)
      end
    end
  end

  let :object do
    double('object')
  end

  let :routes do
    double('routes')
  end

  let :helpers do
    double('helpers')
  end

  let :presenter_class do
    double('presenter_class')
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

  it 'should return an list with data attributes and default data attributes' do
    String.any_instance.stub(:constantize).and_return(presenter)

    object.should_receive(:id).and_return(1)
    object.should_receive(:to_s).and_return('object')
    object.should_receive(:class).exactly(2).times.and_return('Object')
    object.should_receive(:first_name).and_return('Marcelo')

    formatted_data_attributes = "data-value='1' data-label='object' data-type='Object' data-my-first-name='Marcelo'"

    subject.formatted_data_attributes.should eq formatted_data_attributes
  end

  it 'should return only the object when has not the localized method' do
    object.stub(:date => Date.new(2012, 5, 18))

    subject.date.should eq Date.new(2012, 5, 18)
  end

  it 'should return the original object equal to not localized object' do
    subject.original_object.should eq object
  end

  context 'when the object has localized method' do
    before do
      object.should_receive(:localized).and_return(localized_object)
    end

    let :localized_object do
      double('localized_object', :date => "18/05/2012")
    end

    it 'should return localized object' do
      object.stub(:date => Date.new(2012, 5, 18))

      subject.date.should eq "18/05/2012"
    end

    it 'should return the original object equal to not localized object' do
      subject.original_object.should eq object
    end
  end
end

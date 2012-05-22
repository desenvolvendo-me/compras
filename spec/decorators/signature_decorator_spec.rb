require 'decorator_helper'
require 'app/decorators/signature_decorator'

describe SignatureDecorator do
  it 'should return position as summary' do
    component.stub(:position).and_return(double('Position', :to_s => 'Gerente'))
    subject.summary.should eq 'Gerente'
  end
end

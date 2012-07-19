require 'decorator_helper'
require 'app/decorators/signature_decorator'

describe SignatureDecorator do
  context '#summary' do
    before do
      component.stub(:position).and_return(position)
    end

    let :position do
      double('Position', :to_s => 'Gerente')
    end

    it 'should return position as summary' do
      subject.summary.should eq 'Gerente'
    end
  end
end

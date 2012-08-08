require 'decorator_helper'
require 'app/decorators/licitation_commission_decorator'

describe LicitationCommissionDecorator do
  context '#regulatory_act_publication_date' do
    context 'when do not have regulatory_act_publication_date' do
      before do
        component.stub(:regulatory_act_publication_date).and_return(nil)
      end

      it 'should be nil' do
        expect(subject.regulatory_act_publication_date).to be_nil
      end
    end

    context 'when have regulatory_act_publication_date' do
      before do
        component.stub(:regulatory_act_publication_date).and_return(Date.new(2012, 2, 16))
      end

      it 'should localize' do
        expect(subject.regulatory_act_publication_date).to eq '16/02/2012'
      end
    end
  end
end

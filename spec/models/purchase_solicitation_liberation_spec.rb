# encoding: utf-8
require 'model_helper'
require 'app/models/purchase_solicitation_liberation'

describe PurchaseSolicitationLiberation do
  it { should belong_to :responsible }
  it { should belong_to :purchase_solicitation }

  it { should validate_presence_of :date }
  it { should validate_presence_of :justification }
  it { should validate_presence_of :responsible }

  it 'should validate #to_s' do
    subject.stub(:purchase_solicitation).and_return('1/2012 1 - Secretaria de Educação - RESP: Gabriel Sobrinho')
    subject.to_s.should eq 'Liberação da Solicitação de Compra 1/2012 1 - Secretaria de Educação - RESP: Gabriel Sobrinho'
  end
end

# encoding: utf-8
require 'model_helper'
require 'app/models/trading_configuration'

describe TradingConfiguration do
  it 'should return class name as to_s' do
    expect(subject.to_s).to eq 'Configuração do Registro de Preço'
  end

  it "has a default value of 0 to percentage_limit_to_participate_in_bids" do
    expect(subject.percentage_limit_to_participate_in_bids).to eq 0.0
  end

  context "percentage_limit_to_participate_in_bids" do
    it { should_not allow_value(-1).for(:percentage_limit_to_participate_in_bids) }
    it { should allow_value(0).for(:percentage_limit_to_participate_in_bids) }
    it { should allow_value(100).for(:percentage_limit_to_participate_in_bids) }
    it { should_not allow_value(101).for(:percentage_limit_to_participate_in_bids) }
  end
end

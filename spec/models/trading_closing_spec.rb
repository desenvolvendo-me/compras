require 'model_helper'
require 'app/models/trading_closing'

describe TradingClosing do
  it { should belong_to :trading }

  it { should validate_presence_of :trading }
  it { should validate_presence_of :status }

  it 'should retuns the trading and status as to_s' do
    subject.stub(:trading => '1/2012')
    subject.stub(:status_humanize => 'Fracassado')

    expect(subject.to_s).to eq '1/2012 - Fracassado'
  end
end

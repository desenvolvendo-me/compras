require 'model_helper'
require 'app/models/unico/cnae'
require 'app/models/cnae'
# require 'app/models/creditor'

describe Cnae do
  it "return name when call to_s" do
    subject.name = "Produção de lavouras temporária"
    expect(subject.to_s).to eq subject.name
  end

  it { should belong_to :risk_degree }
  it { should have_many(:creditors) }
  it { should have_many(:creditors_with_main_cnae) }

  it { should validate_presence_of :name }
  it { should validate_presence_of :code }

end

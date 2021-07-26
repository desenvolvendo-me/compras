require 'model_helper'
require 'app/models/department'

describe Department do

  context 'relationships' do
    it { should belong_to :purchasing_unit }
  end

  context 'validations' do
    it { should validate_presence_of :description }
  end

  it "return the description when call to_s" do
    subject.description = "Departamento de Compras"
    expect(subject.to_s).to eq 'Departamento de Compras'
  end

end

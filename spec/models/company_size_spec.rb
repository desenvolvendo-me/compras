require 'model_helper'
require 'app/models/unico/company_size'
require 'app/models/company_size'
require 'app/models/company'
require 'app/models/creditor'

describe CompanySize do
  it { should have_many(:companies).dependent(:restrict) }

  context 'default values' do
    it 'uses false as default for boolean values' do
      subject.benefited.should be false
    end
  end
end

require 'model_helper'
require 'app/models/unico/company_size'
require 'app/models/company_size'
require 'app/models/company'
require 'app/models/creditor'

describe CompanySize do
  it { should have_many(:companies).dependent(:restrict) }
end

require 'model_helper'
require 'app/models/persona/company_size'
require 'app/models/company_size'
require 'app/models/extended_company_size'

describe CompanySize do
  it { should have_one(:extended_company_size).dependent(:destroy) }
end

require 'model_helper'
require 'app/models/persona/company_size'
require 'app/models/company_size'
require 'app/models/extended_company_size'
require 'app/models/purchase_process_accreditation_creditor'

describe CompanySize do
  it { should have_one(:extended_company_size).dependent(:destroy) }

  it { should have_many(:purchase_process_accreditation_creditors).dependent(:restrict) }

  it { should delegate(:benefited).to(:extended_company_size).allowing_nil(:true) }
  it { should delegate(:benefited?).to(:extended_company_size).allowing_nil(:true) }
end

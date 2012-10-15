require 'model_helper'
require 'app/uploaders/document_uploader'
require 'app/models/agreement_occurrence'
require 'app/models/agreement_participant'
require 'app/models/agreement_bank_account'
require 'app/models/agreement'
require 'app/models/bank_account_capability'
require 'app/models/bank_account'
require 'app/models/agreement_additive'
require 'app/models/agreement_file'
require 'app/models/tce_capability_agreement'

describe Agreement do
  it { should belong_to :agreement_kind }
  it { should belong_to :regulatory_act }

  it { should have_many(:agreement_bank_accounts).dependent(:destroy) }
  it { should have_many(:tce_specification_capabilities).dependent(:restrict).through(:tce_capability_agreements) }
  it { should have_many(:tce_capability_agreements).dependent(:restrict) }
  it { should have_many(:agreement_occurrences).dependent(:destroy) }
  it { should have_many(:agreement_additives).dependent(:destroy).order(:number) }
  it { should have_many(:agreement_files).dependent(:destroy).order(:id) }
  it { should have_many(:agreement_participants).dependent(:destroy).order(:id) }
end

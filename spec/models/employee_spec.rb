require 'model_helper'
require 'lib/signable'
require 'app/models/employee'
# require 'app/models/purchase_solicitation_budget_allocation'
# require 'app/models/purchase_solicitation'
require 'app/models/purchase_solicitation_liberation'
require 'app/models/licitation_process'
require 'app/models/price_collection'
require 'app/models/legal_analysis_appraisal'
require 'app/models/process_responsible'
require 'app/models/price_collection_proposal'

describe Employee do
  it { should belong_to :individual }
  it { should belong_to :position }

  it { should have_many(:purchase_solicitations_with_liberator).dependent(:restrict) }
  it { should have_many(:purchase_solicitations_with_responsible).dependent(:restrict) }
  it { should have_many(:purchase_solicitation_liberations).dependent(:restrict) }
  it { should have_many(:licitation_processes_with_contact).dependent(:restrict) }
  it { should have_many(:price_collections).dependent(:restrict) }
  it { should have_many(:legal_analysis_appraisals).dependent(:restrict) }
  it { should have_many(:process_responsibles).dependent(:restrict) }
  it { should have_many(:price_collection_proposals).dependent(:restrict) }

  it { should have_one(:street).through(:individual) }
  it { should have_one(:neighborhood).through(:individual) }

  it { should validate_presence_of :individual }
  it { should validate_presence_of :registration }
  it { should validate_presence_of :position }

  it { should allow_value('estevancunhaaraujo@teleworm.us').for(:email) }
  it { should_not allow_value('estevancunhaaraujoteleworm.us').for(:email) }
  it { should_not allow_value('missing.host').for(:email) }

  it { should delegate(:name).to(:individual).allowing_nil(true) }
  it { should delegate(:number).to(:individual).allowing_nil(true) }
  it { should delegate(:issuer).to(:individual).allowing_nil(true) }
  it { should delegate(:cpf).to(:individual).allowing_nil(true) }
  it { should delegate(:zip_code).to(:individual).allowing_nil(true) }
  it { should delegate(:city).to(:individual).allowing_nil(true) }
  it { should delegate(:state).to(:individual).allowing_nil(true) }
  it { should delegate(:email).to(:individual).allowing_nil(true).prefix(true) }
  it { should delegate(:phone).to(:individual).allowing_nil(true).prefix(true) }
  it { should delegate(:name).to(:street).allowing_nil(true).prefix(true) }
  it { should delegate(:name).to(:neighborhood).allowing_nil(true).prefix(true) }
  it { should delegate(:tce_mg_code).to(:city).allowing_nil(true).prefix(true) }
  it { should delegate(:acronym).to(:state).allowing_nil(true).prefix(true) }
end

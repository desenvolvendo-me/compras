require 'model_helper'
require 'app/models/regularization_or_administrative_sanction_reason'

describe RegularizationOrAdministrativeSanctionReason do
  it { should validate_presence_of :description }
  it { should validate_presence_of :reason_type }
end

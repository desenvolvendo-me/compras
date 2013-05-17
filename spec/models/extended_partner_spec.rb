require 'model_helper'
require 'app/models/extended_partner'

describe ExtendedPartner do
  it { should belong_to :partner }

  it { should validate_presence_of :partner }
  it { should validate_presence_of :society_kind }
end

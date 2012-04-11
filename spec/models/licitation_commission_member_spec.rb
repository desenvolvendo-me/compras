# encoding: utf-8
require 'model_helper'
require 'app/models/licitation_commission_member'

describe LicitationCommissionMember do
  it { should belong_to :licitation_commission }
  it { should belong_to :individual }

  it { should validate_presence_of :individual }
  it { should validate_presence_of :role }
  it { should validate_presence_of :role_nature }
  it { should validate_presence_of :registration }
end

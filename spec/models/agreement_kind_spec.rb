# encoding: utf-8
require 'model_helper'
require 'app/models/agreement_kind'

describe AgreementKind do
  it { should have_many(:agreements).dependent(:restrict) }
end

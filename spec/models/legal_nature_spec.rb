# encoding: utf-8
require 'model_helper'
require 'app/models/unico/legal_nature'
require 'app/models/legal_nature'
require 'app/models/administration_type'
require 'app/models/creditor'

describe LegalNature do
  it { should have_many(:administration_types).dependent(:restrict) }
  it { should have_many(:creditors).dependent(:restrict) }
end

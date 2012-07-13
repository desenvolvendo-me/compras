# encoding: utf-8
require 'model_helper'
require 'app/models/unico/legal_nature'
require 'app/models/legal_nature'
require 'app/models/administration_type'

describe LegalNature do
  it { should have_many(:administration_types).dependent(:restrict) }
end

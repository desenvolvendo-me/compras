# encoding: utf-8
require 'model_helper'
require 'app/models/creditor_material'
require 'app/models/creditor'
require 'app/models/material'

describe CreditorMaterial do
  it { should validate_presence_of :creditor }
  it { should validate_presence_of :material }
  it { should belong_to :creditor }
  it { should belong_to :material }
end

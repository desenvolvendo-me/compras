# encoding: utf-8
require 'model_helper'
require 'app/models/creditor_representative'

describe CreditorRepresentative do
  it { should belong_to :creditor }
  it { should belong_to :representative_person }
end

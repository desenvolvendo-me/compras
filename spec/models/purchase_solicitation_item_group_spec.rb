# encoding: utf-8
require 'model_helper'
require 'app/models/purchase_solicitation_item_group'
require 'app/models/purchase_solicitation_item_group_material'

describe PurchaseSolicitationItemGroup do
  it { should have_many(:purchase_solicitation_item_group_materials).dependent(:destroy) }
  it { should have_many(:purchase_solicitations).through(:purchase_solicitation_item_group_materials) }

  it {should validate_presence_of(:purchase_solicitation_item_group_materials).with_message("deve ter ao menos um material") }

  it 'should be id as #to_s method' do
    subject.id = 1

    subject.to_s.should eq '1'
  end
end

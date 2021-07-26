require 'model_helper'
require 'app/models/purchase_process_fractionation'

describe PurchaseProcessFractionation do
  it { should belong_to :material_class }
  it { should belong_to :purchase_process }

  describe 'validations' do
    it { should validate_presence_of :year }
    it { should validate_presence_of :material_class_id }
    it { should validate_presence_of :purchase_process }
    it { should validate_presence_of :value }
    it { should validate_presence_of :object_type }
    it { should validate_presence_of :modality }
    it { should validate_presence_of :type_of_removal }
  end
end

require 'model_helper'
require 'app/models/expense_nature'
require 'app/models/budget_structure'
require 'app/models/material'
require 'app/models/purchase_solicitation_item'
require 'app/models/purchase_solicitation'
require 'app/models/purchase_process_item'
require 'app/models/price_collection_item'
require 'app/models/creditor_material'
require 'app/models/materials_control'

describe Material do
  describe 'default values' do
    it 'uses false as default for combustible' do
      expect(subject.combustible).to be false
    end
  end

  it 'should return code and description as to_s method' do
    subject.code = '01'
    subject.description = 'Manga'
    expect(subject.to_s).to eq '01 - Manga'
  end

  it { should have_many(:purchase_process_items).dependent(:restrict) }
  it { should have_many(:purchase_solicitation_items).dependent(:restrict) }
  it { should have_many(:price_collection_items).dependent(:restrict) }
  it { should have_many(:creditor_materials).dependent(:restrict) }
  it { should have_many(:purchase_solicitations).through(:purchase_solicitation_items).dependent(:restrict) }
  it { should have_many(:purchase_solicitation_budget_allocations).through(:purchase_solicitations).dependent(:restrict) }
  it { should have_many(:materials_controls).dependent(:destroy) }
  it { should have_many(:licitation_processes).through(:purchase_process_items) }

  it { should validate_presence_of :description }
  it { should validate_presence_of :detailed_description }
  it { should validate_presence_of :reference_unit }

  it 'should ensure control_amount to be true or false' do
    expect(subject).to allow_value(true).for(:control_amount)
    expect(subject).to allow_value(false).for(:control_amount)
  end

  it "should have false as the default value of combustible" do
    expect(subject.combustible).to eq false
  end

  it "should destroy if does not have licitation_processes" do
    subject.run_callbacks(:destroy)

    expect(subject.errors[:base]).to_not include "Este registro não pôde ser apagado pois há outros cadastros que dependem dele"
  end

  describe '#autocomplete_material_class' do
    context 'when has a material_class' do
      let(:material_class) { double(:material_class, :to_s => '123 - Software') }

      before do
        subject.stub(:material_class => material_class)
      end

      it 'should returns the material_class to_s' do
        expect(subject.autocomplete_material_class).to eq '123 - Software'
      end
    end

    context 'when does not have a material_class' do
      it 'should returns the material_class to_s' do
        expect(subject.autocomplete_material_class).to eq ''
      end
    end
  end

  describe '#service_without_quantity?' do
    context 'when service' do
      before do
        subject.stub(service?: true)
      end

      context 'with control_amount' do
        before do
          subject.stub(control_amount?: true)
        end

        it 'should be false' do
          expect(subject.service_without_quantity?).to be_false
        end
      end

      context 'without control_amount' do
        before do
          subject.stub(control_amount?: false)
        end

        it 'should be true' do
          expect(subject.service_without_quantity?).to be_true
        end
      end
    end
  end
end

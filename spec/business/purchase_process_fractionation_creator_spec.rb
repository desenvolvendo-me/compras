require 'unit_helper'
require 'app/business/purchase_process_fractionation_creator'

describe PurchaseProcessFractionationCreator do
  let(:item1) { double(:item1, id: 2, marked_for_destruction?: false, estimated_total_price: 1000.0) }
  let(:item2) { double(:item2, id: 5, marked_for_destruction?: true) }
  let(:repository) { double(:repository) }

  let :purchase_process do
    double(:purchase_process,
      id: 7,
      year: 2013,
      object_type: 'object_type',
      modality: 'modality',
      type_of_removal: 'type_of_removal',
      items: [item1, item2])
  end

  describe '#create!' do
    let(:material_class) { double(:material_class, id: 30) }
    let(:fractionation) { double(:fractionation) }
    let(:fractionations){ double(:fractionations) }

    subject do
      described_class.new purchase_process, repository: repository
    end

    context 'when there is no fractionation for year, purchase_process and material_class' do
      context 'when the item does not have ratification' do
        before do
          item1.stub(ratification_item: nil)
        end

        xit "should create the fractionations for the purchase process's items" do
          purchase_process.should_receive(:destroy_fractionations!)

          item1.should_receive(:material_class).and_return(material_class)

          repository.
            should_receive(:where).
            with(year: 2013, purchase_process_id: 7, material_class_id: 30).
            and_return(fractionations)

          fractionations.should_receive(:first_or_initialize).and_return(fractionation)

          fractionation.should_receive(:new_record?).and_return(true)
          fractionation.should_receive(:object_type=).with('object_type')
          fractionation.should_receive(:modality=).with('modality')
          fractionation.should_receive(:type_of_removal=).with('type_of_removal')
          fractionation.should_receive(:value=).with(0.0)
          fractionation.should_receive(:value).and_return(0.0)
          fractionation.should_receive(:value=).with(1000.0)
          fractionation.should_receive(:save!).and_return(true)

          subject.create!
        end
      end

      context 'when the item have ratification' do
        before do
          item1.stub(ratification_item: 'ratification', ratification_item_total_price: 800.0)
        end

        xit "should create the fractionations for the purchase process's items" do
          purchase_process.should_receive(:destroy_fractionations!)

          item1.should_receive(:material_class).and_return(material_class)

          repository.
            should_receive(:where).
            with(year: 2013, purchase_process_id: 7, material_class_id: 30).
            and_return(fractionations)

          fractionations.should_receive(:first_or_initialize).and_return(fractionation)

          fractionation.should_receive(:new_record?).and_return(true)
          fractionation.should_receive(:object_type=).with('object_type')
          fractionation.should_receive(:modality=).with('modality')
          fractionation.should_receive(:type_of_removal=).with('type_of_removal')
          fractionation.should_receive(:value=).with(0.0)
          fractionation.should_receive(:value).and_return(0.0)
          fractionation.should_receive(:value=).with(800.0)
          fractionation.should_receive(:save!).and_return(true)

          subject.create!
        end
      end
    end

    context 'when there is no fractionation for year, purchase_process and material_class' do
      context 'when the item have ratification' do
        before do
          item1.stub(ratification_item: 'ratification', ratification_item_total_price: 800.0)
        end

        xit "should update the fractionations for the purchase process's items" do
          purchase_process.should_receive(:destroy_fractionations!)

          item1.should_receive(:material_class).and_return(material_class)

          repository.
            should_receive(:where).
            with(year: 2013, purchase_process_id: 7, material_class_id: 30).
            and_return(fractionations)

          fractionations.should_receive(:first_or_initialize).and_return(fractionation)

          fractionation.should_receive(:new_record?).and_return(false)
          fractionation.should_not_receive(:object_type=)
          fractionation.should_not_receive(:modality=)
          fractionation.should_not_receive(:type_of_removal=)
          fractionation.should_receive(:value).and_return(500.0)
          fractionation.should_receive(:value=).with(1300.0)
          fractionation.should_receive(:save!).and_return(true)

          subject.create!
        end
      end

      context 'when the item does not have ratification' do
        before do
          item1.stub(ratification_item: nil, ratification_item_total_price: 800.0)
        end

        xexample "should update the fractionations for the purchase process's items" do
          purchase_process.should_receive(:destroy_fractionations!)

          item1.should_receive(:material_class).and_return(material_class)

          repository.
            should_receive(:where).
            with(year: 2013, purchase_process_id: 7, material_class_id: 30).
            and_return(fractionations)

          fractionations.should_receive(:first_or_initialize).and_return(fractionation)

          fractionation.should_receive(:new_record?).and_return(false)
          fractionation.should_not_receive(:object_type=)
          fractionation.should_not_receive(:modality=)
          fractionation.should_not_receive(:type_of_removal=)
          fractionation.should_receive(:value).and_return(500.0)
          fractionation.should_receive(:value=).with(1500.0)
          fractionation.should_receive(:save!).and_return(true)

          subject.create!
        end
      end
    end
  end

  describe '.create!' do
    it 'should call new and create!' do
      instance = double(:instance)

      described_class.
        should_receive(:new).
        with(purchase_process, repository: repository).
        and_return(instance)

      instance.should_receive(:create!)

      described_class.create!(purchase_process, repository: repository)
    end
  end
end

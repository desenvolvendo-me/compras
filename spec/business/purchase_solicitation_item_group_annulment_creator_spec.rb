# encoding: utf-8
require 'unit_helper'
require 'enumerate_it'
require 'app/business/purchase_solicitation_item_group_annulment_creator'

describe PurchaseSolicitationItemGroupAnnulmentCreator do
  subject do
    PurchaseSolicitationItemGroupAnnulmentCreator.new(
      item_group,
      :resource_annul_repository => resource_annul_repository,
      :item_group_annulment => item_group_annulment
    )
  end

  let(:item_group) { double(:item_group, :id => 2, :change_status! => true) }
  let(:item_group_annulment) { double(:item_group_annulment) }
  let(:resource_annul_repository) {
    double(:resource_annul_repository, :create! => nil)
  }

  describe '#create_annulment' do
    it 'should create an resouce_annul and annul it' do
      item_group.stub(:class).and_return(double(:class, :name => 'PurchaseSolicitationItemGroup'))
      annulment_instance = double(:annulment_instance)
      employee = double(:employee, :id => 1)

      resource_annul_repository.should_receive(:create!).
                                with(
                                    :employee_id => 1,
                                    :date => Date.new(2012, 10, 01),
                                    :description => 'Anulação',
                                    :annullable_id => 2,
                                    :annullable_type => 'PurchaseSolicitationItemGroup'
                                  )

      annulment_instance.should_receive(:annul)

      item_group_annulment.should_receive(:new).
                           with(item_group).
                           and_return(annulment_instance)

      subject.create_annulment(employee, Date.new(2012, 10, 01), 'Anulação')
    end
  end
end

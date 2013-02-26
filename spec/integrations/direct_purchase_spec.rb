require 'spec_helper'

describe DirectPurchase do
  describe ".ordered" do
    it "should order by year DESC and budget_structure DESC" do
      direct_purchase_2012_1 = DirectPurchase.make!(:compra)
      direct_purchase_2012_2 = DirectPurchase.make!(:compra_nao_autorizada)
      direct_purchase_2011 = DirectPurchase.make!(:compra_2011)

      expect(DirectPurchase.ordered.to_a).to eq [direct_purchase_2012_2, direct_purchase_2012_1, direct_purchase_2011]
    end
  end

  context "when annulled" do
    it "changes the status of the purchase solicitation item group to Annuled" do
      employee = Employee.make!(:sobrinho)
      item_group = PurchaseSolicitationItemGroup.make!(:antivirus)
      PurchaseSolicitationItemGroupAnnulmentCreator.new(item_group).create_annulment(employee, Date.today)
      expect(item_group.status).to eq PurchaseSolicitationItemGroupStatus::ANNULLED
    end
  end

  describe 'purchase_solicitation_items' do
    it 'should return blank to purchase solicitation items when has not a relationship' do
      direct_purchase = DirectPurchase.make!(:compra)

      expect(direct_purchase.purchase_solicitation_items).to eq []
    end

    it 'should return items with same material to purchase solicitation items when has item on direct purchase' do
      purchase_solicitation  = PurchaseSolicitation.make!(:reparo_liberado)
      direct_purchase = DirectPurchase.make!(:compra)
      direct_purchase.purchase_solicitation = purchase_solicitation
      direct_purchase.save!

      expect(direct_purchase.purchase_solicitation_items).to eq purchase_solicitation.items
    end
  end
end

require 'spec_helper'

describe DirectPurchase do
  describe ".ordered" do
    it "should order by year and budget_structure" do
      direct_purchase_2012_1 = DirectPurchase.make!(:compra)
      direct_purchase_2012_2 = DirectPurchase.make!(:compra_nao_autorizada)
      direct_purchase_2011 = DirectPurchase.make!(:compra_2011)

      expect(DirectPurchase.ordered.to_a).to eq [direct_purchase_2011, direct_purchase_2012_1, direct_purchase_2012_2]
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
end

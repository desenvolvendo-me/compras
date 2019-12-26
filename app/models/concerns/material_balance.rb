module MaterialBalance
  extend ActiveSupport::Concern

  included do

    def self.quantity_autorized(licitation_process, purchase_solicitation, material, contract)
      licitation_process = LicitationProcess.find(licitation_process.id)
      if contract.balance_control_type.eql? "contract"
        quantity_licitation_process = licitation_process.items.where(material_id: material.id).sum(:quantity).to_i
        return quantity_licitation_process
      else
        quantity_purchase_solicitation = licitation_process.purchase_solicitations.where(purchase_solicitation_id: purchase_solicitation.id).first.purchase_solicitation.items.where(material_id: material.id).sum(:quantity).to_i
        return quantity_purchase_solicitation
      end
    end

  end

end
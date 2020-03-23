module MaterialBalance
  extend ActiveSupport::Concern

  included do

    def calc_items_quantity(licitation_process, purchase_solicitation)
      klass = self.class.name
      message = ""
      unless licitation_process.nil?
        self.items.each do |item|
          response = klass.classify.constantize.total_balance(licitation_process, purchase_solicitation, item.material, item.quantity, self, self.contract)
          message = message.present? ? message.concat(", ").concat(response["message"]) : response["message"]
        end
      end
      message
    end

    def self.total_balance(licitation_process, purchase_solicitation, material, quantity, object = nil, contract)
      response = {}
      klass = self.name

      quantity_autorized = quantity_autorized(licitation_process, purchase_solicitation, material, contract)
      quantity_delivered = quantity_delivered(klass, licitation_process, material, object,purchase_solicitation)

      if (quantity_autorized - (quantity_delivered + quantity.to_i)) < 0
        response["message"] = ("#{material.description} (#{quantity_autorized - quantity_delivered})")
      end

      response["total"] = quantity_autorized
      response["balance"] = quantity_autorized - quantity_delivered
      response
    end

    def self.quantity_delivered(klass, licitation_process, material, object,purchase_solicitation)
      objects = klass.classify.constantize.where(licitation_process_id: licitation_process.id,purchase_solicitation_id: purchase_solicitation.id)
      objects = objects.where("compras_#{klass.pluralize.underscore}.id != #{object.id} ") if object.try(:id)
      quantity_delivered = objects.joins(:items).where("compras_#{klass.underscore}_items.material_id = ?", material.id).sum(:quantity).to_f
      return quantity_delivered
    end

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
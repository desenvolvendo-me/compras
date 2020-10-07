module MaterialBalance
  extend ActiveSupport::Concern

  included do

    def calc_items_quantity(licitation_process, purchase_solicitation)
      klass = self.class.name
      message = ""
      unless licitation_process.nil?
        self.items.each do |item|
          response = klass.classify.constantize.total_balance(licitation_process, purchase_solicitation, item.material, item.quantity, self, self.contract)
          message = message.present? ? message.concat(", ").concat(response["message"].to_s) : response["message"].to_s
        end
      end
      message
    end

    def self.total_balance(licitation_process, purchase_solicitation, material, quantity, object = nil, contract)
      response = {}
      klass = self.name

      # retorna a quantidade autorizada pelo processo de compra ou solicitação de compra
      quantity_autorized = quantity_autorized(licitation_process, purchase_solicitation, material, contract)
      # retorna a quantidade items consumida excluindo o 'object' atual
      quantity_delivered = quantity_delivered(klass, licitation_process, material, object, purchase_solicitation)

      if (quantity_autorized - (quantity_delivered + quantity.to_i)) < 0
        response["message"] = ("#{material.description} (#{quantity_autorized - quantity_delivered})")
      end

      qtd_material_unit = material.quantity_unit.to_f || 0
      balance_unit = ((quantity_autorized - quantity_delivered).to_f * qtd_material_unit) - quantity.to_i
      if qtd_material_unit.eql?(0.0)
        balance =  0
        value_unit = 0
      else
        balance = balance_unit.to_f / qtd_material_unit
        value_unit = get_unit_price(object, material, licitation_process, contract) / qtd_material_unit
      end


      response["total"] = quantity_autorized
      response["value_unit"] = value_unit
      response["balance"] = balance
      response["balance_unit"] = balance_unit
      response
    end

    def self.quantity_delivered(klass, licitation_process, material, object, purchase_solicitation)
      objects = klass.classify.constantize.where(licitation_process_id: licitation_process.id, purchase_solicitation_id: purchase_solicitation.id)
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

    def self.get_unit_price(object, material, licitation_process, contract)
      unit_value = nil
      if object
        unit_value = SupplyRequestItem.get_material_unit_value(object.id, object.creditor_id, material.id)
      else
        p = PurchaseProcessItem.where(creditor_id: contract.creditor.id, material_id: material.id, licitation_process_id: licitation_process.id).last
        unit_value = p&.ratification_item&.unit_price
      end

      unit_value.eql?(nil) ? 0.0 : unit_value
    end

  end

end
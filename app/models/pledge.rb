class Pledge < UnicoAPI::Resources::Contabilidade::Pledge
  schema do
    decimal :amount
  end

  def self.by_purchase_process_id(id)
    all(params: { by_purchase_process_id: id })
  end
end

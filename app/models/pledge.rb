class Pledge < UnicoAPI::Resources::Contabilidade::Pledge
  schema do
    decimal :amount
    date    :emission_date
  end

  def self.by_purchase_process_id(id)
    all(params: { by_purchase_process_id: id })
  end
end

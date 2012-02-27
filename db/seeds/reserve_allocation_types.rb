# encoding: utf-8
["Comum", "Licitação", "Cotas mensais", "Limitações de empenho"].each do |description|
  ActiveRecord::Base.transaction do
    ReserveAllocationType.create!(:description => description, :status => Status::ACTIVE)
  end
end

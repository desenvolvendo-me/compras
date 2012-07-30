# encoding: utf-8
require 'enumeration_helper'
require 'app/enumerations/purchase_solicitation_service_status'

describe PurchaseSolicitationServiceStatus do
  it 'should return availables for liberation' do
    described_class.liberation_availables.should eq [["Devolvido para alteração", "returned"],
                                                     ["Liberada", "liberated"],
                                                     ["Não liberada", "not_liberated"]]
  end
end

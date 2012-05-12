#encoding: utf-8

Precatory.blueprint(:precatorio) do
  number { "1234/2012" }
  lawsuit_number { "001.456.1234/2009" }
  provider { Provider.make!(:wenderson_sa) }
  date { Date.new(2012, 1, 1) }
  judgment_date { Date.new(2011, 6, 30) }
  apresentation_date { Date.new(2011, 12, 31) }
  precatory_type { PrecatoryType.make!(:tipo_de_precatorio_ativo) }
  historic { "Precatório Expedido conforme decisão do STJ" }
  value { 6000000.0 }
  precatory_parcels { [PrecatoryParcel.make!(:parcela_paga), PrecatoryParcel.make!(:parcela_a_vencer)] }
end

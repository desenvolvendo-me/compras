#encoding: utf-8
class AddLicitationModalityIdToAdministrativeProcess < ActiveRecord::Migration
  class AdministrativeProcess < Compras::Model; end
  class LegalTextNature < Compras::Model; end
  class RegulatoryActTypeClassification < Compras::Model; end
  class RegulatoryActType < Compras::Model; end
  class RegulatoryAct < Compras::Model; end
  class LicitationModality < Compras::Model; end

  def change
    add_column :compras_administrative_processes, :licitation_modality_id, :integer

    add_index :compras_administrative_processes, :licitation_modality_id, :name => :compras_ap_on_licitation_modality_id

    add_foreign_key :compras_administrative_processes, :compras_licitation_modalities,
                    :column => :licitation_modality_id

    legal_text_nature = LegalTextNature.find_or_create_by_description!('NATUREZA')

    regulatory_act_type_classification = RegulatoryActTypeClassification.find_or_create_by_description!('LEI ORDINÁRIA')

    regulatory_act_type = RegulatoryActType.find_or_create_by_description!('LDO - LEI DAS DIRETRIZES ORÇAMENTÁRIAS') { |r|
      r.regulatory_act_type_classification_id = regulatory_act_type_classification.id
    }

    regulatory_act = RegulatoryAct.find_or_create_by_act_number!('0001') { |r|
      r.creation_date = Date.new(2011, 12, 30)
      r.publication_date = Date.new(2011, 12, 30)
      r.signature_date = Date.new(2011, 12, 30)
      r.vigor_date = Date.new(2012, 1, 1)
      r.end_date = Date.new(2012, 12, 31)
      r.content = "Institui o orçamento anual para o exercício de 2012"
      r.legal_text_nature_id  = legal_text_nature.id
      r.regulatory_act_type_id = regulatory_act_type.id
    }

    modality = LicitationModality.find_or_create_by_description!('4. CONVITE PARA COMPRAS E SERVIÇOS') { |m|
      m.initial_value = 8000.01
      m.final_value = 80000.00
      m.regulatory_act_id = regulatory_act.id
      m.object_type = 'purchase_and_services'
    }

    AdministrativeProcess.all.each do |administrative_process|
      administrative_process.update_column(:licitation_modality_id, modality.id)
    end

    remove_column :compras_administrative_processes, :modality
  end
end

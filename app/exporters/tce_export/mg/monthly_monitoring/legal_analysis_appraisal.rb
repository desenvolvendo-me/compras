module TceExport::MG
  module MonthlyMonitoring
    class LegalAnalysisAppraisalDataGenerator < DataGeneratorBase
      def generate_data
        query.map do |analysis|
          {
            cod_orgao: monthly_monitoring.organ_code,
            exercicio_licitacao: analysis.year,
            nro_processo_licitatorio: analysis.process,
            data_parecer: analysis.appraisal_expedition_date,
            tipo_parecer: appraisal_type(analysis),
            nro_cpf: only_numbers(analysis.responsible_cpf),
            nom_resp_parecer: analysis.responsible_name,
            logradouro:  analysis.responsible_street_name,
            bairro_logra: analysis.responsible_neighborhood_name,
            cod_cidade_logra: analysis.responsible_city_tce_mg_code,
            uf_cidade_logra: analysis.responsible_state_acronym,
            cep_logra: only_numbers(analysis.responsible_zip_code),
            telefone: only_numbers(analysis.responsible_phone),
            email: analysis.responsible_email
          }
        end
      end

      private

      def query
        LegalAnalysisAppraisal.type_of_purchase_licitation.
          by_ratification_month_and_year(monthly_monitoring.month, monthly_monitoring.year).
          uniq
      end

      def appraisal_type(analysis)
        if analysis.appraisal_type_technical?
          1
        elsif analysis.appraisal_type_legal?
          if analysis.reference_notice? || analysis.reference_draft?
            2
          elsif analysis.reference_public_session?
            3
          elsif analysis.reference_others?
            4
          end
        end
      end

      def budget_structure_code(budget)
        Formatters::BudgetStructureCodeFormatter.new(monthly_monitoring.organ_code, budget)
      end
    end

    class LegalAnalysisAppraisalFormatter < FormatterBase
      attribute :cod_orgao, position: 0, size: 2, min_size: 2, required: true,
                caster: Casters::TextCaster
      attribute :cod_unidade_sub, position: 1, multiple_size: [5, 8], required: false,
                caster: Casters::TextCaster
      attribute :exercicio_licitacao, position: 2, size: 4, min_size: 4, required: true,
                caster: Casters::IntegerCaster
      attribute :nro_processo_licitatorio, position: 3, size: 12, min_size: 1, required: true,
                caster: Casters::TextCaster
      attribute :data_parecer, position: 4, size: 8, min_size: 8, required: true,
                caster: Casters::DateCaster
      attribute :tipo_parecer, position: 5, size: 1, min_size: 1, required: true,
                caster: Casters::IntegerCaster
      attribute :nro_cpf, position: 6, size: 11, min_size: 11, required: true,
                caster: Casters::TextCaster
      attribute :nom_resp_parecer, position: 7, size: 50, min_size: 1, required: true,
                caster: Casters::TextCaster
      attribute :logradouro, position: 8, size: 75, min_size: 1, required: true,
                caster: Casters::TextCaster
      attribute :bairro_logra, position: 9, size: 50, min_size: 1, required: true,
                caster: Casters::TextCaster
      attribute :cod_cidade_logra, position: 10, size: 5, min_size: 5, required: true,
                caster: Casters::TextCaster
      attribute :uf_cidade_logra, position: 11, size: 2, min_size: 2, required: true,
                caster: Casters::TextCaster
      attribute :cep_logra, position: 12, size: 8, min_size: 8, required: true,
                caster: Casters::IntegerCaster
      attribute :telefone, position: 13, size: 10, min_size: 10, required: true,
                caster: Casters::IntegerCaster
      attribute :email, position: 14, size: 50, min_size: 1, required: true,
                caster: Casters::TextCaster

      def error_description(attribute, error_type)
        [
          "nro_processo_licitatorio: #{data[:nro_processo_licitatorio]}",
          "exercicio_licitacao: #{data[:exercicio_licitacao]}",
          "#{attribute}: #{data[attribute]}"
        ].join("\n")
      end
    end

    class LegalAnalysisAppraisalGenerator < GeneratorBase
      acronym 'PARELIC'

      formatters formatter: LegalAnalysisAppraisalFormatter

      formats :format_data

      private

      def format_data(data)
        lines << formatter.new(data, self).to_s
      end
    end
  end
end

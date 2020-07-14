module TceExport::MG
  module MonthlyMonitoring
    class ProcessResponsibleMemberDataGenerator < DataGeneratorBase
      def initialize(monthly_monitoring, responsible)
        @monthly_monitoring = monthly_monitoring
        @responsible = responsible
      end

      def generate_data
        query.map do |member|
          {
            tipo_registro: 20,
            cod_orgao: monthly_monitoring.organ_code,
            exercicio_licitacao: responsible.licitation_process_year,
            nro_processo_licitatorio: responsible.licitation_process_process,
            cod_tipo_comissao: commission_type_number(member),
            descricao_ato_nomeacao: classification(member),
            nro_ato_nomeacao: member.regulatory_act_act_number,
            data_ato_nomeacao: member.licitation_commission_nomination_date,
            inicio_vigencia: member.regulatory_act_vigor_date,
            final_vigencia: member.regulatory_act_end_date,
            cpf_membro_comissao: only_numbers(member.individual_cpf),
            nom_membro_com_lic: member.individual_name,
            cod_atribuicao: role(member),
            cargo: member.position_name,
            natureza_cargo: role_nature(member),
            logradouro: member.street_name,
            bairro_logra: member.neighborhood_name,
            cod_cidade_logra: member.city_tce_mg_code,
            uf_cidade_logra: member.state_acronym,
            cep_logra: only_numbers(member.individual_zip_code),
            telefone: only_numbers(member.individual_phone),
            email: member.individual_email
          }
        end
      end

      private

      attr_reader :responsible

      def query
        responsible.licitation_commission_members
      end

      def commission_type_number(member)
        member.licitation_commission_permanent? ? 2 : 1
      end

      def classification(member)
        return 1 if member.regulatory_act_classification_ordinance?
        return 2 if member.regulatory_act_classification_decree?
      end

      def role_nature(member)
        case member.role_nature
        when LicitationCommissionMemberRoleNature::EFECTIVE_SERVER
          1
        when LicitationCommissionMemberRoleNature::TEMPORARY_SERVER
          2
        when LicitationCommissionMemberRoleNature::COMMISSION_ROLE
          3
        when LicitationCommissionMemberRoleNature::PUBLIC_EMPLOYEE
          4
        when LicitationCommissionMemberRoleNature::PUBLIC_AGENT
          5
        when LicitationCommissionMemberRoleNature::OTHERS
          6
        end
      end

      def role(member)
        case member.role
        when LicitationCommissionMemberRole::MEMBER
          2
        when LicitationCommissionMemberRole::ALTERNATE
          2
        when LicitationCommissionMemberRole::SUPPORT
          2
        when LicitationCommissionMemberRole::SUPPORT_TEAM
          2
        when LicitationCommissionMemberRole::VICE_PRESIDENT
          3
        when LicitationCommissionMemberRole::PRESIDENT
          3
        when LicitationCommissionMemberRole::VICE_SECRETARY
          4
        when LicitationCommissionMemberRole::SECRETARY
          4
        when LicitationCommissionMemberRole::SUBSTITUTE_AUCTIONEER
          6
        when LicitationCommissionMemberRole::AUCTIONEER
          6
        end
      end

      def budget_structure_code(budget)
        Formatters::BudgetStructureCodeFormatter.new(monthly_monitoring.organ_code, budget)
      end
    end

    class ProcessResponsibleDataGenerator < DataGeneratorBase
      def generate_data
        query.map do |responsible|
          {
            tipo_registro: 10,
            cod_orgao: monthly_monitoring.organ_code,
            exercicio_licitacao: responsible.licitation_process_year,
            nro_processo_licitatorio: responsible.licitation_process_process,
            tipo_resp: responsible_kind(responsible),
            nro_cpf_resp: only_numbers(responsible.cpf),
            nome_resp: responsible.name,
            logradouro: responsible.street_name,
            bairro_logra: responsible.neighborhood_name,
            cod_cidade_logra: responsible.city_tce_mg_code,
            uf_cidade_logra: responsible.state_acronym,
            cep_logra: only_numbers(responsible.zip_code),
            telefone: only_numbers(responsible.phone),
            email: responsible.email,
            members: generate_members(responsible)
          }
        end
      end

      private

      def query
        ProcessResponsible.licitation.order(:id)
      end

      def generate_members(responsible)
        ProcessResponsibleMemberDataGenerator.
          new(monthly_monitoring, responsible).
          generate_data
      end

      def responsible_kind(responsible)
        case responsible.stage_process_description
        when 'Autorização para abertura do procedimento licitatório'
          1
        when 'Emissão do edital'
          2
        when 'Pesquisa de preços'
          3
        when 'Informação de existência de recursos orçamentários'
          4
        when 'Condução do procedimento licitatório'
          5
        when 'Homologação'
          6
        when 'Adjudicação'
          7
        when 'Publicação em órgão Oficial'
          8
        when 'Avaliação de Bens'
          9
        end
      end

      def budget_structure_code(budget)
        Formatters::BudgetStructureCodeFormatter.new(monthly_monitoring.organ_code, budget)
      end
    end

    class ProcessResponsibleFormatter < FormatterBase
      attribute :tipo_registro, position: 0, size: 2, min_size: 2, required: true, caster: Casters::IntegerCaster
      attribute :cod_orgao, position: 1, size: 2, min_size: 2, required: true, caster: Casters::TextCaster
      attribute :cod_unidade_sub, position: 2, multiple_size: [5, 8], required: false, caster: Casters::TextCaster
      attribute :exercicio_licitacao, position: 3, size: 4, min_size: 4, required: true, caster: Casters::IntegerCaster
      attribute :nro_processo_licitatorio, position: 4, size: 12, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :tipo_resp, position: 5, size: 1, min_size: 1, required: true, caster: Casters::IntegerCaster
      attribute :nro_cpf_resp, position: 6, size: 11, min_size: 11, required: true, caster: Casters::TextCaster
      attribute :nome_resp, position: 7, size: 50, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :logradouro, position: 8, size: 75, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :bairro_logra, position: 9, size: 50, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :cod_cidade_logra, position: 10, size: 5, min_size: 5, required: true, caster: Casters::TextCaster
      attribute :uf_cidade_logra, position: 11, size: 2, min_size: 2, required: true, caster: Casters::TextCaster
      attribute :cep_logra, position: 12, size: 8, min_size: 8, required: true, caster: Casters::IntegerCaster
      attribute :telefone, position: 13, size: 10, min_size: 10, required: true, caster: Casters::IntegerCaster
      attribute :email, position: 14, size: 50, min_size: 1, required: true, caster: Casters::TextCaster

      def error_description(attribute, error_type)
        [
          "tipo_registro: #{data[:tipo_registro]}",
          "nro_processo_licitatorio: #{data[:nro_processo_licitatorio]}",
          "exercicio_licitacao: #{data[:exercicio_licitacao]}",
          "#{attribute}: #{data[attribute]}"
        ].join("\n")
      end
    end

    class LicitationCommissionMemberFormatter < FormatterBase
      attribute :tipo_registro, position: 0, size: 2, min_size: 2, required: true, caster: Casters::IntegerCaster
      attribute :cod_orgao, position: 1, size: 2, min_size: 2, required: true, caster: Casters::TextCaster
      attribute :cod_unidade_sub, position: 2, multiple_size: [5, 8], required: false, caster: Casters::TextCaster
      attribute :exercicio_licitacao, position: 3, size: 4, min_size: 4, required: true, caster: Casters::IntegerCaster
      attribute :nro_processo_licitatorio, position: 4, size: 12, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :cod_tipo_comissao, position: 5, size: 1, min_size: 1, required: true, caster: Casters::IntegerCaster
      attribute :descricao_ato_nomeacao, position: 6, size: 1, min_size: 1, required: true, caster: Casters::IntegerCaster
      attribute :nro_ato_nomeacao, position: 7, size: 7, min_size: 1, required: true, caster: Casters::IntegerCaster
      attribute :data_ato_nomeacao, position: 8, size: 8, min_size: 8, required: true, caster: Casters::DateCaster
      attribute :inicio_vigencia, position: 9, size: 8, min_size: 8, required: true, caster: Casters::DateCaster
      attribute :final_vigencia, position: 10, size: 8, min_size: 8, required: true, caster: Casters::DateCaster
      attribute :cpf_membro_comissao, position: 11, size: 11, min_size: 11, required: true, caster: Casters::TextCaster
      attribute :nom_membro_com_lic, position: 12, size: 50, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :cod_atribuicao, position: 13, size: 1, min_size: 1, required: true, caster: Casters::IntegerCaster
      attribute :cargo, position: 14, size: 50, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :natureza_cargo, position: 15, size: 1, min_size: 1, required: true, caster: Casters::IntegerCaster
      attribute :logradouro, position: 16, size: 75, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :bairro_logra, position: 17, size: 50, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :cod_cidade_logra, position: 18, size: 5, min_size: 5, required: true, caster: Casters::TextCaster
      attribute :uf_cidade_logra, position: 19, size: 2, min_size: 2, required: true, caster: Casters::TextCaster
      attribute :cep_logra, position: 20, size: 8, min_size: 8, required: true, caster: Casters::IntegerCaster
      attribute :telefone, position: 21, size: 10, min_size: 10, required: true, caster: Casters::IntegerCaster
      attribute :email, position: 22, size: 50, min_size: 1, required: true, caster: Casters::TextCaster

      def error_description(attribute, error_type)
        [
          "tipo_registro: #{data[:tipo_registro]}",
          "nro_processo_licitatorio: #{data[:nro_processo_licitatorio]}",
          "exercicio_licitacao: #{data[:exercicio_licitacao]}",
          "#{attribute}: #{data[attribute]}"
        ].join("\n")
      end
    end

    class ProcessResponsibleGenerator < GeneratorBase
      acronym 'RESPLIC'

      formatters responsible_formatter: ProcessResponsibleFormatter,
                 member_formatter: LicitationCommissionMemberFormatter

      formats :format_responsible, :format_members

      private

      def format_responsible(data)
        lines << responsible_formatter.new(data.except(:members), self).to_s
      end

      def format_members(data)
        return unless data[:members]

        data[:members].each { |member| format_member(member) }
      end

      def format_member(member)
        lines << member_formatter.new(member, self).to_s
      end
    end
  end
end

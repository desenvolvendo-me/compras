# encoding: utf-8
module TceExport::MG
  module MonthlyMonitoring
    class MonthlyProcessResponsible
      def initialize(options = {})
        @generator = options.fetch(:generator) { MonthlyProcessResponsibleGenerator }
        @responsible_formatter = options.fetch(:responsible_formatter) { MonthlyProcessResponsibleFormatter }
        @member_formatter = options.fetch(:member_formatter) { MonthlyLicitationCommissionMemberFormatter }
      end

      def generate_file(monthly_monitoring)
        @monthly_monitoring = monthly_monitoring

        File.open(path, 'w', :encoding => 'ISO-8859-1') do |f|
          f.write(formatted_data)
        end

        filename
      end

      private

      attr_reader :generator, :responsible_formatter, :member_formatter, :monthly_monitoring

      def filename
        'RESPLIC.csv'
      end

      def path
        "tmp/#{filename}"
      end

      def formatted_data
        generate_data.map do |data|
          [format_responsible(data), format_members(data)].compact.join("\n")
        end.join("\n")
      end

      def format_responsible(data)
        responsible_formatter.new(data.except(:members)).to_s
      end

      def format_members(data)
        return unless data[:members]

        data[:members].map do |member|
          format_member(member)
        end.compact.join("\n")
      end

      def format_member(member)
        member_formatter.new(member).to_s
      end

      def generate_data
        generator.generate_data(monthly_monitoring)
      end
    end

    class MonthlyProcessResponsibleGenerator
      def initialize(monthly_monitoring)
        @monthly_monitoring = monthly_monitoring
      end

      def self.generate_data(*args)
        new(*args).generate_data
      end

      def generate_data
        ProcessResponsible.licitation.order(:id).map do |responsible|
          {
            tipo_registro: 10,
            cod_orgao: monthly_monitoring.organ_code,
            cod_unidade_sub: responsible.execution_unit_responsible,
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

      attr_reader :monthly_monitoring

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

      def generate_members(responsible)
        responsible.licitation_commission_members.map do |member|
          {
            tipo_registro: 10,
            cod_orgao: monthly_monitoring.organ_code,
            cod_unidade_sub: responsible.execution_unit_responsible,
            exercicio_licitacao: responsible.licitation_process_year,
            nro_processo_licitatorio: responsible.licitation_process_process,
            cod_tipo_comissao: member_commission_type_number(member),
            descricao_ato_nomeacao: member_classification(member),
            nro_ato_nomeacao: member.regulatory_act_act_number,
            data_ato_nomeacao: member.licitation_commission_nomination_date,
            inicio_vigencia: member.regulatory_act_vigor_date,
            final_vigencia: member.regulatory_act_end_date,
            cpf_membro_comissao: only_numbers(member.individual_cpf),
            nom_membro_com_lic: member.individual_name,
            cod_atribuicao: member_role(member),
            cargo: member.position_name,
            natureza_cargo: member_role_nature(member),
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

      def only_numbers(data)
        return unless data

        data.gsub(/\D/, '')
      end

      def member_commission_type_number(member)
        member.licitation_commission_permanent? ? 2 : 1
      end

      def member_classification(member)
        return 1 if member.regulatory_act_classification_ordinance?
        return 2 if member.regulatory_act_classification_decree?
      end

      def member_role_nature(member)
        case member.role_nature
        when LicitationCommissionMemberRoleNature::EFECTIVE_SERVER
          1
        when LicitationCommissionMemberRoleNature::TEMPORARY_SERVER
          2
        when LicitationCommissionMemberRoleNature::COMISSION_ROLE
          3
        when LicitationCommissionMemberRoleNature::PUBLIC_EMPLOYEE
          4
        when LicitationCommissionMemberRoleNature::PUBLIC_AGENT
          5
        when LicitationCommissionMemberRoleNature::OTHERS
          6
        end
      end

      def member_role(member)
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
    end

    class MonthlyProcessResponsibleFormatter
      include Typecaster

      output_separator ";"

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
    end
  end

  class MonthlyLicitationCommissionMemberFormatter
    include Typecaster

    output_separator ";"

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
  end
end

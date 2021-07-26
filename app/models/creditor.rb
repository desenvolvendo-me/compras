class Creditor < Persona::Creditor
  reload_custom_data

  attr_accessible :material_ids, :representatives_attributes
  attr_accessor :representative_person

  has_many :creditor_materials, :dependent => :destroy, :inverse_of => :creditor
  has_many :bidders, :dependent => :restrict
  has_many :licitation_processes, :through => :bidders, :dependent => :restrict
  has_many :materials, :through => :creditor_materials, :order => :id
  has_many :material_classes, :through => :materials
  has_many :precatories, :dependent => :restrict
  has_many :price_collection_proposals, :dependent => :restrict, :order => :id
  has_many :price_collections, :through => :price_collection_proposals
  has_many :registration_cadastral_certificates, :dependent => :destroy
  has_many :regularization_or_administrative_sanctions, :inverse_of => :creditor, :dependent => :destroy
  has_many :purchase_process_accreditation_creditors, :dependent => :restrict
  has_many :purchase_process_items, :dependent => :restrict
  has_many :purchase_process_creditor_proposals, dependent: :restrict
  has_many :realignment_prices, dependent: :restrict
  has_many :proposal_disqualifications, class_name: 'PurchaseProcessCreditorDisqualification', dependent: :restrict
  has_many :licitation_process_ratifications, dependent: :restrict
  has_many :licitation_process_ratification_items, through: :licitation_process_ratifications
  has_many :contracts

  #Todo remover isso apos verificar dependencias
  has_many :representative_people, :through => :representatives, :source => :representative_person
  has_many :representatives, :class_name => 'CreditorRepresentative', :dependent => :destroy, :order => :id

  validates :contract_start_date, :social_identification_number, :presence => true, :if => :autonomous?
  validates :documents, :no_duplication => :document_type_id
  validate :person_in_representatives
  validate :secondary_cnae_in_main_cnae
  # validate :representatives?
  validate :licitation_processes?

  before_save :clean_fields_when_is_no_autonomous
  before_validation :clear


  def clear

    _validators.reject! { |k| k == :person }
    _validate_callbacks.each do |callback|
      callback.raw_filter.attributes.delete :person if callback.raw_filter.is_a?(ActiveModel::Validations::PresenceValidator)
    end

  end

  scope :by_purchasing_unit, lambda {|q|
    department_ids = DepartmentPerson.where(user_id: q).pluck(:department_id)
    purchasing_unit_ids = Department.where(id: department_ids).pluck(:purchasing_unit_id)
    licitation_process_ids = LicitationProcess.where(purchasing_unit_id: purchasing_unit_ids).pluck(:id)
    creditor_ids = Contract.where(licitation_process_id: licitation_process_ids).pluck(:creditor_id).uniq

    where(id: creditor_ids)
  }

  scope :term, lambda {|q|
    joins {person}.
        where {person.name.like("%#{q}%")}
  }

  scope :by_id, lambda {|id|
    where {|creditor| creditor.id.eq(id)}
  }

  scope :by_contract, lambda {|contract_id|
    joins {contracts}.
        where {contracts.id.eq(contract_id)}
  }

  scope :accreditation_purchase_process_id, ->(purchase_process_id) do
    joins {purchase_process_accreditation_creditors.purchase_process_accreditation}.
        where {
          purchase_process_accreditation_creditors.purchase_process_accreditation.licitation_process_id.eq(purchase_process_id)
        }
  end

  scope :enabled_by_licitation, lambda {|licitation_process_id|
    joins {bidders}.
        where {(bidders.licitation_process_id.eq licitation_process_id) & (bidders.enabled.eq 't')}
  }

  scope :winner_without_disqualifications, -> {
    joins {purchase_process_creditor_proposals}.
        where {
          (purchase_process_creditor_proposals.ranking.eq 1) &
              (purchase_process_creditor_proposals.disqualified.not_eq 't')
        }.uniq
  }

  scope :enabled_or_benefited_by_purchase_process_id, -> purchase_process_id do
    joins {bidders.creditor.person.personable(Company).outer.company_size.outer.extended_company_size.outer}.
        where {
          (bidders.enabled.eq('t') | compras_extended_company_sizes.benefited.eq(true)) &
              bidders.licitation_process_id.eq(purchase_process_id)
        }.uniq
  end

  # Quando o processo de compra for por compra direta, faz o filtro de todos
  # os fornecedores vencedores de algum  item.
  scope :without_direct_purchase_ratification, lambda {|licitation_process_id|
    #filtra os que já tem ratificações cadastradas
    creditor_ids = LicitationProcess.find(licitation_process_id)&.licitation_process_ratification_creditor_ids

    scoped.select {'unico_creditors.*, unico_people.name'}.
        joins {purchase_process_items.licitation_process.licitation_process_ratifications.outer}.
        joins {person}.
        where {
          purchase_process_items.licitation_process_id.eq(licitation_process_id) &
              purchase_process_items.creditor_id.not_in(creditor_ids)
        }.uniq
  }

  scope :by_ratification_and_licitation_process_id, ->(licitation_process_id) do
    joins {licitation_process_ratifications}.
        where {|query| query.licitation_process_ratifications.licitation_process_id.eq(licitation_process_id)}
  end

  scope :without_licitation_ratification, lambda {|licitation_process_id|
    creditor_ids = LicitationProcess.find(licitation_process_id).licitation_process_ratification_creditor_ids

    scoped.select {'unico_creditors.*, unico_people.name'}.
        joins {bidders.licitation_process.licitation_process_ratifications.outer}.
        joins {person}.
        where {
          bidders.licitation_process_id.eq(licitation_process_id) &
              bidders.creditor_id.not_in(creditor_ids)
        }.uniq
  }

  scope :won_calculation, lambda {|licitation_process_id|
    joins {bidders.licitation_process.creditor_proposals}.
        where {|query|
          query.bidders.licitation_process.creditor_proposals.licitation_process_id.eq(licitation_process_id) &
              query.bidders.licitation_process.creditor_proposals.ranking.eq(1)
        }.
        where {'"unico_creditors".id = "compras_purchase_process_creditor_proposals".creditor_id'}.
        uniq
  }

  scope :won_calculation_for_trading, lambda {|licitation_process_id|
    creditor_ids = LicitationProcess.find(licitation_process_id).trading_items.map {|item|
      TradingItemWinner.new(item).creditor.try(:id)
    }.reject(&:nil?)

    scoped.where("unico_creditors.id in (?)", creditor_ids)
  }

  scope :by_bidders, lambda{|licitation_process|
    joins(:bidders).where(compras_bidders:{licitation_process_id: licitation_process})
  }

  scope :winners, ->(purchase_process) do
    query = scoped.enabled_by_licitation(purchase_process.id)

    if purchase_process.licitation?
      if purchase_process.trading?
        query = scoped.
            accreditation_purchase_process_id(purchase_process.id).
            won_calculation_for_trading(purchase_process.id)
      else
        query = query.won_calculation(purchase_process.id)
      end
    end

    query.order(:id)
  end

  # def representatives?
  #   if self.representatives.blank?
  #     errors.add(:representative_person, :blank)
  #   end
  # end

  def licitation_processes?
    if self.licitation_processes.where(status: ["in_progress", "waiting_for_open"]).any?
      errors.add(:representatives, "Não poder ser alterado, pois existem licitações com o status Em Andamento ou Aguardando Abertura com o fornecedor")
    end
  end

  def proposal_by_item(purchase_process_id, item)
    purchase_process_creditor_proposals.
        by_item_id(item.id).
        licitation_process_id(purchase_process_id).
        first
  end

  def proposal_by_lot(purchase_process_id, lot)
    purchase_process_creditor_proposals.
        licitation_process_id(purchase_process_id).
        by_lot(lot).
        first
  end

  def first_representative_individual
    representative_people.joins {personable(Individual)}.first
  end

  def ratification_by_licitation purchase_process_id
    licitation_process_ratifications
        .licitation_process_id(purchase_process_id).first
  end

  def destroy
#    super
  rescue ActiveRecord::DeleteRestrictionError
    errors.add(:base, :cant_be_destroyed)
    false
  end

  def creditor_representative
    person.personable.try(:responsible_name) if person.company?
  end

  def licitation_realignment_price licitation_process
    realignment_prices.map{|x| x if x.purchase_process_id == licitation_process.id}.reject(&:nil?)
  end

  protected

  def clean_fields_when_is_no_autonomous
    return if autonomous?

    self.contract_start_date = nil
    self.social_identification_number = nil
  end

  def person_in_representatives
    return unless person && representatives

    if person && representative_person_ids.include?(person.id)
      errors.add(:representatives, :cannot_have_representative_equal_creditor)
    end
  end

  def secondary_cnae_in_main_cnae
    return unless main_cnae && cnaes

    if cnae_ids.include? main_cnae.id
      errors.add(:cnaes, :cannot_have_secondary_cnae_equal_main_cnae)
    end
  end
end

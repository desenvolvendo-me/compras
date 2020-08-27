class LicitationCommission < Compras::Model
  include Unico::CustomData
  reload_custom_data

  attr_accessible :commission_type, :nomination_date, :expiration_date,
                  :exoneration_date, :description, :regulatory_act_id,
                  :licitation_commission_responsibles_attributes,
                  :licitation_commission_members_attributes

  attr_modal :commission_type, :nomination_date, :expiration_date,
             :exoneration_date, :description

  has_enumeration_for :commission_type,
                      :create_helpers => true, :create_scopes => true

  belongs_to :regulatory_act

  has_many :licitation_commission_responsibles, :dependent => :destroy, :order => :id
  has_many :licitation_commission_members, :dependent => :destroy, :order => :id
  has_many :judgment_commission_advices, :dependent => :restrict

  accepts_nested_attributes_for :licitation_commission_responsibles, :allow_destroy => true
  accepts_nested_attributes_for :licitation_commission_members, :allow_destroy => true

  delegate :publication_date, :to => :regulatory_act, :allow_nil => true, :prefix => true
  delegate :auctioneer, :support_team, :to => :licitation_commission_members

  validates :commission_type, :nomination_date, :expiration_date, :regulatory_act, :presence => true
  validates :expiration_date, :exoneration_date,
    :timeliness => {
      :on_or_after => :nomination_date,
      :type => :date,
      :on_or_after_message => :should_be_on_or_after_nomination_date
    }, :allow_blank => true
  validates :licitation_commission_responsibles, :licitation_commission_members, :no_duplication => :individual_id
  validate :must_have_one_member_in_licitation_commission
  validate :validate_custom_data

  orderize "id DESC"
  filterize

  def to_s
    "#{description} - Tipo: #{commission_type_humanize} - Data de Nomeação: #{I18n.l(nomination_date)}"
  end

  def president
    licitation_commission_members.president.first
  end

  def president_name
    commission_president = president
    commission_president.individual.to_s if commission_president
  end

  def expired?(base_date=Date.current)
    expiration_date < base_date
  end

  protected

  def must_have_one_member_in_licitation_commission
    if licitation_commission_members.empty?
      errors.add(:licitation_commission_members, :must_have_one_member_in_licitation_commission)
    end
  end
end

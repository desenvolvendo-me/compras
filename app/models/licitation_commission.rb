# encoding: utf-8
class LicitationCommission < Compras::Model
  include CustomData
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
  validate :must_have_one_member_with_role_president, :unless => :trading?
  validate :must_have_auctioneer, :must_have_support_team, :if => :trading?
  validate :validate_custom_data

  orderize "id DESC"
  filterize

  def self.can_take_part_in_trading
    trading.not_expired.not_exonerated
  end

  def self.not_expired
    where { expiration_date >= Date.current }
  end

  def self.not_exonerated
    where { exoneration_date.eq(nil) }
  end

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

  def exonerated?
    exoneration_date.present?
  end

  protected

  def must_have_one_member_with_role_president
    if presidents.empty?
      errors.add(:licitation_commission_members, :must_have_one_president)
    elsif presidents.count > 1
      errors.add(:licitation_commission_members, :must_have_only_one_president)
    end
  end

  def must_have_auctioneer
    if auctioneer.empty?
      errors.add(:licitation_commission_members, :must_have_one_auctioneer)
    end
  end

  def must_have_support_team
    if support_team.empty?
      errors.add(:licitation_commission_members, :must_have_one_support_team_member)
    end
  end

  def auctioneer
    licitation_commission_members.select(&:auctioneer?)
  end

  def support_team
    licitation_commission_members.select(&:support_team?)
  end

  def presidents
    licitation_commission_members.select(&:president?)
  end
end

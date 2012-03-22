class MovimentType < ActiveRecord::Base
  attr_accessible :name, :operation, :character

  has_enumeration_for :operation, :with => MovimentTypeOperation
  has_enumeration_for :character, :with => MovimentTypeCharacter

  validates :name, :operation, :character, :presence => true

  def to_s
    name
  end
end

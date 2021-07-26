class Precatory < Compras::Model
  belongs_to :creditor

  def to_s
    number
  end
end

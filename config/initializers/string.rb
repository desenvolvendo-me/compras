class String
  def date?
    begin
      self.to_date
    rescue
      return false
    end

    true
  end
end

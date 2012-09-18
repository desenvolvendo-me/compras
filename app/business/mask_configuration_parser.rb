class MaskConfigurationParser
  def self.from_levels(levels)
    final_mask = ''

    levels.each_with_index do |level, index|
      final_mask << digits(level)

      final_mask << separator(level, index, levels.size)
    end

    final_mask
  end

  protected

  def self.partial_mask(level, index)
    digits(level) + separator(level, index)
  end

  def self.digits(level)
    return '' if level.digits.blank?

    '9' * level.digits
  end

  def self.separator(level, index, size)
    return '' unless level.separator && index.succ < size

    level.separator
  end
end

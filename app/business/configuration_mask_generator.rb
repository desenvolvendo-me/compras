class ConfigurationMaskGenerator
  attr_accessor :levels

  def initialize(levels)
    self.levels = levels
  end

  def generate!
    final_mask = ''

    levels.each_with_index do |level, index|
      next if level.digits.blank?

      final_mask << '9' * level.digits

      if level.separator && index.succ < levels.count
        final_mask << level.separator
      end
    end

    final_mask
  end

  protected

  def partial_mask(level, index)
    digits(level) + separator(level, index)
  end

  def digits(level)
    return '' if level.digits.blank?

    '9' * level.digits
  end

  def separator(level, index)
    return '' unless level.separator && index.succ < levels.size

    level.separator
  end
end

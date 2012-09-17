class ConfigurationMaskGenerator
  attr_accessor :levels

  def initialize(levels)
    self.levels = levels
  end

  def generate!
    return if empty?

    final_mask = ''

    levels.each_with_index do |level, index|
      next if level.digits.blank?

      final_mask << '9' * level.digits

      if level.separator && index.succ < count
        final_mask << level.separator
      end
    end

    final_mask
  end

  protected

  def count
    levels.size
  end

  def empty?
    levels.empty?
  end
end

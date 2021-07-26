class OptionsParser
  def initialize(options)
    @options = options
  end

  def parse
    split_into_array.map { |option| format_option(option) }
  end

  private

  attr_reader :options

  def format_option(option)
    if option.include?('-')
      [option, option.split('-').first.strip]
    else
      option
    end
  end

  def split_into_array
    normalized_options = options.split(',').map(&:strip)
  end
end

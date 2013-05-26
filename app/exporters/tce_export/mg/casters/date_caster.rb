module TceExport::MG::Casters
  module DateCaster
    extend Validators

    def self.call(value, options)
      validate_blank(value, options)

      value.blank? ? " " : value.strftime('%d%m%Y')
    end
  end
end

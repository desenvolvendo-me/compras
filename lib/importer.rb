require 'csv'

class Importer
  def import!
    transaction do
      parser.foreach(file, options) do |row|
        attributes = normalize_attributes(row.to_hash)
        storage.create!(attributes)
      end
    end
  end

  protected

  def storage
    raise NotImplementedError
  end

  def transaction(&block)
    storage.transaction(&block)
  end

  def parser
    CSV
  end

  def file
    raise NotImplementedError
  end

  def options
    { :col_sep => ';', :headers => true }
  end

  def normalize_attributes(attributes)
    attributes
  end
end

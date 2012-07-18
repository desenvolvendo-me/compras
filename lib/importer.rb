# encoding: utf-8
require 'csv'

class Importer
  def import!
    transaction do
      parser.foreach(file, options) do |row|
        attributes = normalize_attributes(row.to_hash)
        repository.create!(attributes)
      end
    end
  end

  protected

  def repository
    raise NotImplementedError
  end

  def transaction(&block)
    repository.transaction(&block)
  end

  def parser
    CSV
  end

  def file
    raise NotImplementedError
  end

  def options
    { :col_sep => ';', :headers => true, :encoding => 'utf-8' }
  end

  def normalize_attributes(attributes)
    attributes
  end
end

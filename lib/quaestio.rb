module Quaestio
  extend ActiveSupport::Concern

  included do
    class_attribute :repository_class, instance_reader: false, instance_writer: false
  end

  module ClassMethods
    def repository(repository_class)
      self.repository_class = repository_class
    end

    def search(params)
      new(params).search
    end
  end

  def initialize(options = {})
    @attributes = options
  end

  def search
    searched = relation

    attributes.each do |attribute, value|
      searched = searched.send(attribute, *value)
    end

    searched
  end

  def relation
    return @relation if @relation

    @relation = self.class.repository_class.extending(self.class::Scopes)

    @relation
  end

  private

  attr_reader :attributes
end

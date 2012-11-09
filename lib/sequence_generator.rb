require 'active_support/concern'
# Auto generate a number for a group of unique fields
#
# Options available:
#   - by (optional)
#   - on (optional)
#
#   By:
#    This option defines the fields to be grouped. When the combination of
#    these fields repeats the sequence is incremented
#
#    - can be a single field or an array of fields
#    - default value is an empty array (Every new record will generate a new sequence)
#
#   On:
#     Defines when the callback that generate a new sequence will be executed.
#
#     - Default value is :before_create
#     - Values allowed are all callbacks previously defined by rails
#
#   Scope:
#     Allows the use of a scope, instead of fields to group, on the sequence generator
#
#     - overrides the by option
#     - can be a single scope only
#
#  How to use
#
#  class Person < ActiveRecord::Base
#    auto_increment :code, :by => :cpf
#  end
#
#  Same thing:
#    auto_increment :code, :by => :cpf
#    auto_increment :code, :by => :cpf, :on => :before_create
#    auto_increment :code, :by => [:cpf]
#    auto_increment :code, :by => [:cpf], :on => :before_create
module SequenceGenerator
  extend ActiveSupport::Concern

  included do
    self.class_attribute :sequencer_field
    self.class_attribute :sequencer_callback
    self.class_attribute :sequence_group
    self.class_attribute :query_scope
  end

  module ClassMethods
    def auto_increment(field, options)
      self.sequencer_field = field
      self.sequence_group = Array(options[:by])
      self.sequencer_callback = options.fetch(:on, :before_create)
      self.query_scope = options[:scope]

      set_sequence_updater_callback
    end

    protected

    def set_sequence_updater_callback
      self.send(sequencer_callback, :set_next_sequence)
    end
  end


  protected

  def set_next_sequence
    return if sequence_value.present?

    write_attribute(sequencer_field, next_sequence)
  end

  def sequence_value
    send sequencer_field
  end

  def sequence_query
    query = self.class

    if query_scope
      query = query.send(query_scope, self)
    else
      sequence_group.each do |field|
        field_value = read_attribute field

        query = query.where(field => field_value)
      end
    end

    query
  end

  def last_sequence
    sequence_query.maximum(sequencer_field).to_i
  end

  def next_sequence
    last_sequence.succ
  end
end

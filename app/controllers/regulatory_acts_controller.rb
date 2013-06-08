class RegulatoryActsController < CrudController
  has_scope :created_at_before, :only => :modal, :type => :hash, :using => [:year, :month, :day]
end

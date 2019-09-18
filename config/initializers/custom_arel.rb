module Arel
  module Predications
    def matches(other)
      unaccent_self  = Nodes::NamedFunction.new 'unaccent', [self]
      unaccent_other = Nodes::NamedFunction.new 'unaccent', [other]

      Nodes::Matches.new unaccent_self, unaccent_other
    end
  end
end

module ActiveRecord
  module SpawnMethods
    # It merge two scopes from same model with an OR statement
    # Example:
    #   > Foo.by_name('bar').merge_or(Foo.by_last_name('baz'))
    #   Foo Load (0.1ms)  SELECT "foo".* FROM "foo" WHERE ("foo"."name" = 'bar') OR ("foo"."last_name" = 'baz')
    def merge_or(other)
      relation = clone
      my_where = relation.where_clauses.join(' AND ')
      other_where = other.where_clauses.join(' AND ')

      full_where = "(#{my_where}) OR (#{other_where})"
      eager_load_join = relation.eager_load_values + other.eager_load_values
      preload_join = relation.preload_values + other.preload_values
      includes_join = relation.includes_values + other.includes_values

      query = klass.
        joins(relation.joins_values + other.joins_values).
        order(relation.order_values + other.order_values).
        where(full_where)

      query = query.eager_load(eager_load_join) if eager_load_join.any?
      query = query.preload(preload_join) if preload_join.any?
      query = query.includes(includes_join) if includes_join.any?

      query
    end
  end
end

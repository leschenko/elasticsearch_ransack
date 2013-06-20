module TireRansack
  class Predicate
    attr_reader :name, :regexp, :query

    def initialize(name, opts={})
      @name = name
      @regexp = opts[:regexp] || Regexp.new("^(.+)_#{@name}$")
      @query = opts[:query]
      raise(ArgumentError, ':query option is required') unless @query
    end
  end
end
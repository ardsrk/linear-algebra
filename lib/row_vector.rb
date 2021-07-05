module Nearli
  class RowVector

    include Enumerable

    def initialize(vector)
      @vector = vector
    end

    def each(&block)
      if block_given?
        @vector.each { |el| yield(el) }
      else
        @vector.each
      end
    end

    def at(i)
      @vector[i]
    end

    def to_s
      "[#{collect.to_a.join(', ')}]"
    end
  end
end

module Nearli
  class RowVector

    include Enumerable

    def initialize(vector)
      @vector = vector
    end

    def dup
      RowVector.new(@vector.dup)
    end

    def collect!(&block)
      if block_given?
        @vector.each_with_index do |el, i|
          @vector[i] = yield(el)
        end
      else
        @vector.to_enum(:collect!)
      end
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

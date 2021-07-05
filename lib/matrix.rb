require_relative './row_vector'
require_relative './vector'
module Nearli
  class Matrix

    include Enumerable

    def initialize(rows)
      @row_vectors =
        rows.collect do |row|
          RowVector.new(row)
        end
    end

    def columns
      @row_vectors.first.count
    end

    def rows
      @row_vectors.count
    end

    def each(&block)
      if block_given?
        @row_vectors.each { |el| yield(el) }
      else
        @row_vectors.each
      end
    end

    def at(i, j)
      @row_vectors[i].at(j)
    end

    def to_s
      collect.to_a.join("\n")
    end

    def multiply_by_vector(v)
      if columns != v.count
        raise "multiplication not possible"
      end

      Nearli::Vector.new(rows.times.collect do |i|
        v.count.times.collect do |j|
          at(i,j) * v.at(j)
        end.sum
      end)
    end

    def *(am)
      if Nearli::Vector === am
        return multiply_by_vector(am)
      end

      if columns != am.rows
        raise "multiplication not possible"
      end

      self.class.new(rows.times.collect do |i|
        am.columns.times.collect do |j|
          am.columns.times.collect do |k|
            at(i,k) * am.at(k,j)
          end.sum
        end
      end)
    end
  end
end

if $PROGRAM_NAME == __FILE__
  n = Nearli::Matrix.new [
    [1,2],
    [3,4]
  ]
  v = Nearli::Vector.new([1,2])
  puts "n = \n#{n}"
  puts "v         = #{v}"
  puts "n*v       = #{n*v}"
  puts "n*n       = \n#{n*n}"
end


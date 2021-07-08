require_relative './row_vector'
require_relative './vector'
module Nearli
  class Matrix

    include Enumerable

    def initialize(rows)
      @row_vectors =
        rows.collect do |row|
          if RowVector === row
            row
          else
            RowVector.new(row)
          end
        end
    end

    def dup
      rows = @row_vectors.collect {|v| v.dup}
      Matrix.new(rows)
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

    def swap!(i, j)
      puts "swap row #{i} and #{j}" if $DEBUG
      tmp = @row_vectors[i]
      @row_vectors[i] = @row_vectors[j]
      @row_vectors[j] = tmp
      puts "#{self}" if $DEBUG
    end

    def scale!(r, j)
      val = at(r, j)
      puts "Divide row #{r} by #{val} @(#{r},#{j}); " if $DEBUG
      @row_vectors[r].collect! do |el|
        Rational(el, val)
      end
      puts "#{self}" if $DEBUG
    end

    def reduce!(k, j, r)
      val = -at(k, j)
      scaled_r = @row_vectors[r].collect do |el|
        val * el
      end

      puts "reduce row #{k} by #{val} * #{@row_vectors[r]}. r = #{r}" if $DEBUG
      @row_vectors[k].collect!.with_index do |el, i|
        rat = Rational(scaled_r[i] + el)
      end
      puts "#{self}" if $DEBUG
    end

    def remove_denominators!
      0.upto(@row_vectors.count - 1) do |i|
        @row_vectors[i].collect!.with_index do |el, i|
          case el.class.name
          when "Rational"
            (el.denominator == 1) ? el.numerator : el
          else
            el
          end
        end
      end
    end

    def row_reduce
      a = self.dup
      r = -1 
      a.columns.times do |j|
        i = r + 1
        while i < a.rows and a.at(i,j) == 0
          i = i + 1
        end
        if i < a.rows
          r = r + 1
          a.swap!(i, r) if i != r
          a.scale!(r, j)
          0.upto(a.rows-1) do |k|
            if k != r
              a.reduce!(k, j, r)
            end
          end
        end
      end
      a.remove_denominators!
      return r, a
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

  puts "==== Row Reduce Echelon Form"
  a = Nearli::Matrix.new [
    [-7, -6, -12, -33],
    [5, 5, 7, 24],
    [1, 0, 4, 5]
  ]
  puts "a = \n#{a}"
  r, ra = a.row_reduce
  puts "Row Reduced form of a = \n#{ra}"
end

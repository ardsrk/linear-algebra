class Vector

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

  def to_s
    "[#{collect.to_a.join(', ')}]"
  end

  def +(av)
    if self.count == av.count
      Vector.new(self.zip(av).collect do |a, b|
        a + b
      end)
    else
      raise "Length of vectors are not the same."
    end
  end

  def *(num)
    Vector.new(collect do |el|
      el * num
    end)
  end

  # Dot product, Inner scalar, or projection product
  def dot(av)
    if self.count != av.count
      raise "Length of vectors are not the same."
    end

    self.zip(av).collect do |a, b|
      a * b
    end.sum
  end

  def size
    Math.sqrt(dot(self))
  end
end

if $PROGRAM_NAME == __FILE__
  r = Vector.new([3,4])
  s = Vector.new([5,6])
  puts "r       = #{r}"
  puts "r + r   = #{r + r}"
  puts "r * 2   = #{r * 2}"
  puts "s       = #{s}"
  puts "r . s   = #{r.dot(s)}"
  puts "size(r) = #{r.size}"
end

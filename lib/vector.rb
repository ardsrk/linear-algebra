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
  # See Vector#angle
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

  # Angle between vectors in degrees.
  # Cosine rule: r . s = |r||s|cos(theta)
  # The cosine rule implies that dot product of two
  # orthogonal vectors is zero.
  def angle(av)
    cos_t = self.dot(av)/(size * av.size)
    angle_in_radians = Math.acos(cos_t)
    (180/Math::PI) * angle_in_radians
  end

  def scalar_projection_on(av)
    av.dot(self) / av.size.to_f
  end

  def vector_projection_on(av)
    av * (scalar_projection_on(av) / av.size)
  end
end

if $PROGRAM_NAME == __FILE__
  r = Vector.new([1,0])
  s = Vector.new([0,1])
  puts "r          = #{r}"
  puts "s          = #{s}"
  puts "r + r      = #{r + r}"
  puts "r * 2      = #{r * 2}"
  puts "r . s      = #{r.dot(s)}"
  puts "size(r)    = #{r.size}"
  puts "r.angle(s) = #{r.angle(s)}"

  puts "\n\n==== Projection ====\n\n"
  r = Vector.new([2,2])
  s = Vector.new([1,1])
  puts "r = #{r}"
  puts "s = #{s}"
  puts "Scalar projection of s on r = #{s.scalar_projection_on(r)}"
  puts "Vector projection of s on r = #{s.vector_projection_on(r)}"
end

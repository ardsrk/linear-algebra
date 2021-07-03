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
end

if $PROGRAM_NAME == __FILE__
  v = Vector.new([1,2,3,4])
  puts "v     = #{v}"
  puts "v + v = #{v + v}"
  puts "v * 2 = #{v * 2}"
end

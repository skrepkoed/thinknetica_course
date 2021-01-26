# frozen_string_literal: true

class Triangle
  attr_accessor :a, :b, :c

  def self.get_lengths
    print 'Введите длинну а:'

    a = gets

    print 'Введите длинну b:'

    b = gets

    print 'Введите длинну c:'

    c = gets

    new(a, b, c).type
  end

  def initialize(a, b, c)
    sides = [a, b, c].map(& :to_f).sort!
    @a, @b, @c = *sides
    @type = []
  end

  def right_tringle?
    @type << 'прямоугольный' if a**2 + b**2 == c**2
  end

  def isosceles_triangle?
    @type << 'равнобедренный' if a == b || b == c || c == a
  end

  def eqilateral_triangle?
    @type << 'равносторонний' if a == b && b == c
  end

  def impossible_triangle?
    @type << 'вырожденный' unless a + b >= c && c + b >= a && a + c >= b
  end

  def type
    report = 'Треугольник'
    if impossible_triangle?

    elsif isosceles_triangle? && eqilateral_triangle?

    elsif right_tringle?

    elsif @type.empty?
      @type << 'неравносторонний'
    end

    if @type.length == 2

      print "#{report} #{@type[0]} и #{@type[1]}."

    else

      print "#{report} #{@type[0]}."

    end
  end
end

Triangle.get_lengths

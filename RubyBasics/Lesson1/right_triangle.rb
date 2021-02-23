# frozen_string_literal: true

class Triangle
  attr_reader :a, :b, :c

  def self.get_lengths
    print 'Введите длинну а:'
    a = gets.to_f

    print 'Введите длинну b:'
    b = gets.to_f

    print 'Введите длинну c:'
    c = gets.to_f

    new(a, b, c)
  end

  def initialize(a, b, c)
    sides = [a, b, c].sort!
    @a, @b, @c = *sides
    @type = []
    type
  end

  def type
    if impossible_triangle?
      @type << 'вырожденный'
    elsif eqilateral_triangle?
      @type = %w[равнобедренный равносторонний]
    elsif isosceles_triangle?
      @type << 'равнобедренный'
    elsif right_triangle?
      @type << 'прямоугольный'
    elsif @type.empty?
      @type << 'неравносторонний'
    end
    report
  end

  private

  def right_triangle?
    a**2 + b**2 == c**2
  end

  def isosceles_triangle?
    a == b || b == c || c == a
  end

  def eqilateral_triangle?
    a == b && b == c
  end

  def impossible_triangle?
    a + b <= c || c + b <= a || a + c <= b
  end

  def report
    report = 'Треугольник'
    if @type.length == 2
      print "#{report} #{@type[0]} и #{@type[1]}."
    else
      print "#{report} #{@type[0]}."
    end
  end
end

Triangle.get_lengths

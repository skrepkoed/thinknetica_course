# frozen_string_literal: true

class QuadraticEquation
  attr_accessor :a, :b, :c, :x1, :x2

  def self.get_coefficient
    print 'Введите коэффициент а:'

    a = gets

    print 'Введите коэффициент b:'

    b = gets

    print 'Введите коэффициент c:'

    c = gets

    new(a, b, c)
  end

  def initialize(a, b, c)
    coefficients = [a, b, c].map(& :to_f)

    @a, @b, @c = *coefficients
  end

  def discriminant
    @discriminant = b**2 - 4 * a * c
  end

  def solve_equation
    discriminant
    case @discriminant <=> 0
    when 1 then eq_roots
                solition = "Ответ: дискриминант=#{@discriminant}, х1=#{@x1},x2=#{@x2}"
    when 0 then eq_root
                solition = "Ответ: дискриминант=#{@discriminant}, х1=x2=#{@x1}"
    when -1 then solition = 'Корней нет'
    end
    print solition
  end

  def eq_root
    @x1 = (-1 * b) / (2 * a)
  end

  def eq_roots
    discriminant = Math.sqrt(@discriminant) / (2 * a)
    extremum = eq_root
    @x1 = extremum + discriminant
    @x2 = extremum - discriminant
  end
end

QuadraticEquation.get_coefficient.solve_equation

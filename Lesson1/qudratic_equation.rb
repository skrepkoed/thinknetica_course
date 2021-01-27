# frozen_string_literal: true

class QuadraticEquation
  attr_reader :a, :b, :c, :x1, :x2, :discriminant

  def self.get_coefficients
    print 'Введите коэффициент а:'
    a = gets.to_f

    print 'Введите коэффициент b:'
    b = gets.to_f

    print 'Введите коэффициент c:'
    c = gets.to_f

    new(a, b, c)
  end

  def initialize(a, b, c)
    @a = a
    @b = b
    @c = c
  end

  def calculate_discriminant
    @discriminant = b**2 - 4 * a * c
  end

  def solve_equation
    calculate_discriminant
    case discriminant <=> 0
    when 1 then eq_roots
                solition = "Ответ: дискриминант=#{discriminant}, х1=#{x1}, x2=#{x2}."
    when 0 then eq_root
                solition = "Ответ: дискриминант=#{discriminant}, х1=x2=#{x1}."
    when -1 then solition = "Ответ: дискриминант=#{discriminant}, корней нет."
    end
    puts solition
  end

  private

  def eq_root
    @x1 = (-1 * b) / (2 * a)
    @x2 = @x1
  end

  def eq_roots
    rooted_discriminant = Math.sqrt(discriminant) / (2 * a)
    extremum = eq_root
    @x1 = extremum + rooted_discriminant
    @x2 = extremum - rooted_discriminant
  end
end

QuadraticEquation.get_coefficients.solve_equation

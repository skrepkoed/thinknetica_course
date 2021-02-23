# frozen_string_literal: true

def triangle_area
  puts 'Введите длину основания:'
  base = gets.to_f
  puts 'Введите длину высоты:'
  height = gets.to_f
  print "Площадь треугольника равна: #{0.5 * base * height} ."
end

triangle_area

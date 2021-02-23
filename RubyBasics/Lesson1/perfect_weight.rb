# frozen_string_literal: true

def perfect_weight(name, height)
  name.chomp!.capitalize!
  perfect_weight = ((height - 110) * 1.15).floor(2)

  if perfect_weight.negative?
    print "#{name}, Ваш вес уже идеальный."
  else
    print "#{name}, Ваш идеальный вес: #{perfect_weight} ."
  end
end
puts 'Введите ваше имя:'
name = gets
puts 'Введите ваш рост в сантиметрах:'
height = gets.to_f

perfect_weight(name, height)

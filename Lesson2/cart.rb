cart = {}

loop do
  puts 'Введите название товара'
  item = gets.chomp
  break if item == 'стоп'

  puts 'Введите цену за единицу товара'
  price = gets.chomp.to_f
  puts 'Введите количество товара'
  number = gets.chomp.to_f
  cart[item] = { price: price, number: number }
end
total = 0
cart.each do |item, feature|
  total_price = feature[:price] * feature[:number]
  puts "#{item}, цена:#{feature[:price]},количество:#{feature[:number]}, итого:#{total_price}"
  total += total_price
end
puts "Итоговая сумма всех покупок: #{total}"

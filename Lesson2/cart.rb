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
cart.each do |item, options|
  total_price = options[:price] * options[:number]
  puts "#{item}, цена:#{options[:price]},количество:#{options[:number]}, итого:#{total_price}"
  total += total_price
end
puts "Итоговая сумма всех покупок: #{total}"

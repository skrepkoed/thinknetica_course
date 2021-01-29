months = {
  January: 31, February: [28, 29], March: 31, April: 30,
  May: 31, June: 30, July: 31, August: 31,
  September: 30, October: 31, November: 30, December: 31
}
months_names = months.keys
def leap_year?(year)
  ((year % 4).zero? && year % 100 != 0) || (year % 400).zero?
end

puts 'Enter year: '
year = gets.chomp.to_i

month_number = loop do
  puts 'Enter month: '
  month_number = gets.chomp.to_i - 1

  break month_number if month_number <= 11
end

day = loop do
  puts 'Enter day: '
  day = gets.chomp.to_i

  break day if day <= months[months_names[month_number]]
end

months[:February] = leap_year?(year) ? 29 : 28

number_of_day = months_names[0...month_number].inject(0) { |number, month| number + months[month] } + day

puts "#{day} #{months_names[month_number]} #{year} is #{number_of_day} day in this year."

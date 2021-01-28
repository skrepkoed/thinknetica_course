months = { April: 30, June: 30, September: 30, November: 30, January: 31, March: 31,
           May: 31, July: 31, August: 31, October: 31,
           December: 31, February: [28, 29] }
ordered_months = %i[January February March April May June July August September October November December]
def leap_year?(year)
  ((year % 4).zero? && year % 100 != 0) || (year % 400).zero?
end

puts 'Enter year: '
year = gets.chomp.to_i
puts 'Enter month: '
month = gets.chomp.to_i - 1
puts 'Enter day: '
day = gets.chomp.to_i

months[:February] = if leap_year?(year)
                      29
                    else
                      28
                    end

number_of_day = ordered_months[0...month].inject(0) { |number, month| number + months[month] } + day

puts "#{day} #{ordered_months[month]} #{year} is #{number_of_day} day in this year."

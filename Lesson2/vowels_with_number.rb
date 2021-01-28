vowels = %w[a e i o u y]

vowels_with_number = {}

vowels.each { |vowel| vowels_with_number[vowel.to_sym] = vowel.ord - 96 }

puts vowels_with_number

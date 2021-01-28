def array_with_gap(range, step)
  first_step = range.first
  range.select do |item|
    first_step += step if item == first_step + step
    item unless (item == (first_step + 1)) .. (item == (first_step + step - 1))
  end
end
print array_with_gap(10..100, 5)

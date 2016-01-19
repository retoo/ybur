
20.times do |i|
  numbers = []
  rand(44).times do |c|
    numbers << rand(12345)
  end

  sum = numbers.inject(0) {|s, v| s + v}

  interactor.send numbers.join(",")
  nr = interactor.get_number
  check sum, nr
end
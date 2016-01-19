words = %w(hello world how are you)

words.each do |word|
  interactor.send word
  result = interactor.get
  check word, result
end
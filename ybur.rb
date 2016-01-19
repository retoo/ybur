$: << "lib"
require 'ybur'

suite = ARGV.shift
folder = ARGV.shift

ybur = Ybur::Checker.new(suite, folder)

ybur.check
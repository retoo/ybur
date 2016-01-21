$: << File.expand_path(File.dirname(__FILE__) + "/lib/")
require 'ybur'
$stderr.puts __FILE__.inspect
$stderr.puts $LOAD_PATH
suite = File.expand_path(File.dirname(__FILE__) + "/ex/")
folder = ARGV.shift

ybur = Ybur::Checker.new(suite, folder)

ybur.check

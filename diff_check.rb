require 'bundler'
Bundler.require

require 'diff/lcs'
require 'csv'

bef_ary = CSV.read('bef.txt')
aft_ary = CSV.read('aft.txt')

bef_ary.each_with_index do |bef, i|
  sdiff = Diff::LCS.sdiff(bef, aft_ary[i])

  # -- CSVヘッダを取得
  @header = bef if i == 0

  puts "----- line: #{i+1} -----"

  sdiff.each do |line|
    next if line.action == '='

    puts "action:#{line.action}, column:#{@header[line.old_position]}, old:#{line.old_element}, new:#{line.new_element}"
  end
end

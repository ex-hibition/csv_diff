# -- CSVファイルの差分を抽出して比較する
# -- CSVファイルの1行目はヘッダ

require 'bundler'
Bundler.require

require 'diff/lcs'
require 'csv'


# -- diff結果を出力するクラス
class DiffCheck
  attr_accessor :header

  def initialize
    @header = []
  end

  # -- カラム比較
  def diff_columns(bef:, aft:)
    (0..bef.size-1).each do |i|
      sdiff = Diff::LCS.sdiff(bef[i], aft[i])
    
      # -- CSVヘッダを取得
      self.header = bef[i] if i == 0

      # -- ヘッダ行は0行目
      puts "----- line: #{i} -----" if i != 0
    
      sdiff.each do |line|
        next if line.action == '='
        puts "action:#{line.action}, column:#{header[line.old_position]}, old:#{line.old_element}, new:#{line.new_element}"
      end
    end
  end

  # -- 行比較
  def diff_lines(bef:, aft:)
    diffs = Diff::LCS.diff(bef, aft)
    
    diffs.each do |diff|
      diff.each do |line|
        element = line.element.to_a.join(',')
        puts "action:#{line.action}, line:#{line.position}, element:#{element}"
      end
    end
  end

end


if $0 == __FILE__
  begin
    # -- 引数チェック
    if ARGV.size != 2
      puts "usage : #{$0} /path/old.csv /path/new.csv"
      exit 1
    end 

    options = {encoding: 'UTF-8'}
    bef = CSV.read(ARGV[0], options)
    aft = CSV.read(ARGV[1], options)
    
    check = DiffCheck.new
    
    # -- ファイル行数が一致したらカラム単位、不一致なら行単位で比較
    if bef.size == aft.size
      puts '# column単位で比較'
      check.diff_columns(bef: bef, aft: aft)
    else
      puts '# line単位で比較'
      check.diff_lines(bef: bef, aft: aft)
    end
  rescue StandardError => err
    p err
  end
end


require 'spec_helper'

describe DiffCheck do
  # -- パッチ前データ
  let(:bef) { bef = [["COL1","COL2","COL3"],["0001","foo","bar"],["0002","baz","qux"]] }
  let(:check) { DiffCheck.new }

  describe '#diff_columns' do
    # -- パッチ後データ(行数一致)
    let(:aft) { aft = [["COL1","COL2","COL3"],["0091","hoge","bar"],["0002","baz",""]] }
    subject { check.diff_columns(bef: bef, aft: aft).size }
    it 'カラム単位の差分(3箇所)が検知できる' do
      is_expected.to eq 3
    end
  end

  describe '#diff_lines' do
    # -- パッチ後データ(行数相違)
    let(:aft) { aft = [["COL1","COL2","COL3"],["0091","hoge","bar"],["0002","baz",""],["0003","quux","corge"]] }
    subject { check.diff_lines(bef: bef, aft: aft).flatten.size }
    it '行単位の差分(5行)が検知できる' do
      is_expected.to eq 5
    end
  end
end
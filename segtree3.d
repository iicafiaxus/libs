/*
セグメント木 区分木 segtree segment tree
範囲に書き込み、1点で読み出す。
たとえば、 [l, r) の範囲を x に更新するクエリがくるなど。

※書き込み操作は、べき等でなければならない
（f(x, y) = f( f(x, y), y)）
たとえば、典型的には 上書き代入（つまり f(x, y) = y）
あとは &= とか…？（上書き代入以外は未テスト）


使用例
auto seg = new SegTree!long(0, n, (x, y) => y, 0);

引数
a, b　添字の範囲。 この意味はa から b - 1 までなので注意。
apply　(x, y) => すでに値 x があるところに y を与えるとどうなるか ※べき等な演算である必要がある
initial　初期値

*/
class SegTree(T){
	T delegate(T, T) apply;
	T initial;
	int a, b; // a <= x < b を担当する
	bool hasValue;
	SegTree left, right; // 左の子(a <= x < c)、右の子(c <= x < b)
	T value;
	this(int a, int b, T delegate(T, T) apply, T initial = T.init){
		this.a = a, this.b = b;
		this.apply = apply;
		this.initial = initial;
		this.value = initial;
		if(b - a == 1){
			this.hasValue = 1;
		}
		else{
			int c = (a + b) / 2;
			this.left = new SegTree(a, c, apply, initial);
			this.right = new SegTree(c, b, apply, initial);
		}
	}
	
	// [a, b) に値を設定する ※[a, b) はこのノードの担当区間とかぶっていなくてもよい
	void setValue(int a, int b, T value){
		if(b <= this.a || this.b <= a) return;
		if(a <= this.a && this.b <= b){
			this.hasValue = true;
			this.value = apply(this.value, value);
		}
		else{
			if(this.hasValue){
				left.setValue(left.a, left.b, this.value);
				right.setValue(right.a, right.b, this.value);
				this.hasValue = false;
			}
			left.setValue(a, b, value);
			right.setValue(a, b, value);
		}
	}
	
	// iにおける値 ※iは必ずこのノードの担当区間内である前提
	T getValue(int i){
		assert(a <= i && i < b);
		if(this.hasValue) return this.value;
		else if(i < left.b) return left.getValue(i);
		else return right.getValue(i);
	}
	
	// 配列に変換したもの（デバッグ用）
	T[] array(){
		T[] res;
		foreach(i; a .. b) res ~= this.value;
		return res;
	}
	
	// 文字列に変換したもの（デバッグ用）
	override string toString(){
		if(this.hasValue) return this.array.to!string;
		else return left.toString ~ right.toString;
	}
}

// テストコード
// AOJ DSL Range Update Query
// http://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=DSL_2_D&lang=ja#
// N Q
// q_1
// q_2
// ...
// q_Q
// クエリの意味は、
// 0 s t x … s から t までを x に更新する（1から始まり、両端を含む）
// 1 i … a_i を更新（1から始まる）
// 初期値は a_i = 1L<<31 - 1
import std.stdio, std.string, std.conv, std.array, std.math, std.algorithm;
void main(){
	int n, q; {
		int[] tmp = readln.chomp.split.to!(int[]);
		n = tmp[0], q = tmp[1];
	}
	auto seg = new SegTree!int(0, n, (x, y) => y, 0);
	seg.setValue(0, n, (1L<<31) - 1);
	seg.writeln;
	foreach(_; 0 .. q){
		int[] tmp = readln.chomp.split.to!(int[]);
		if(tmp[0] == 0){
			int l = tmp[1], r = tmp[2] + 1, x = tmp[3];
			seg.setValue(l, r, x);
			writeln("l:", l, " r:", r, " x:", x);
			seg.writeln;
		}
		else{
			int i = tmp[1];
			writeln("i:", i);
			seg.getValue(i).writeln;
		}
	}}

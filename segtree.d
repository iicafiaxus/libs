/*
セグメント木 区分木 segtree segment tree
1点に書き込み、範囲で読み出す。
たとえば [l, r) の最大値を求めるなど。

引数
a, b　添字の範囲。 この意味はa から b - 1 までなので注意。
merge　左の子と右の子から自分の値をきめる関数（たとえばmax）
neutral　すべての x に対して merge(x, z) = x をみたすz（たとえば-infty）

*/
class SegTree(T){
	T value;
	T neutral;
	SegTree left, right; // 左の子(a <= x < c)、右の子(c <= x < b)
	bool hasValue;
	bool isTerminal;
	int a, b; // a <= x < b を担当する
	T delegate(T, T) merge;
	this(int a, int b, T delegate(T, T) merge, T neutral = T.init){
		this.a = a, this.b = b;
		this.merge = merge;
		this.neutral = neutral;
		if(b - a == 1){
			this.isTerminal = 1;
		}
		else{
			int c = (a + b) / 2;
			this.left = new SegTree(a, c, merge, neutral);
			this.right = new SegTree(c, b, merge, neutral);
		}
	}
	
	// [a, b) における値を読む ※[a, b) はこのノードの担当区間とかぶっていなくてもよい
	T getValue(int a, int b){
		if(b <= this.a || this.b <= a) return neutral;
		if(a <= this.a && this.b <= b){
			if(! this.hasValue){
				T v1 = this.left.getValue(a, b), v2 = this.right.getValue(a, b);
				T v = merge(v1, v2);
				this.value = v;
				this.hasValue = 1;
			}
			return this.value;
		}
		else{
			T v1 = this.left.getValue(a, b), v2 = this.right.getValue(a, b);
			T v = merge(v1, v2);
			return v;
		}
	}
	
	
	// i における値を設定
	void setValue(int i, T value){
		assert(a <= i && i < b);
		this.hasValue = 0;
		if(this.isTerminal){
			this.hasValue = 1;
			this.value = value;
		}
		else if(i < left.b) left.setValue(i, value);
		else right.setValue(i, value);
	}
	
	// 配列に変換したもの（デバッグ用）
	T[] array(){
		if(this.isTerminal) return [this.value];
		else return this.left.array ~ this.right.array;
	}
	
	// 文字列に変換したもの（デバッグ用）
	override string toString(){
		return this.array.to!string;
	}
}

// テストコード
// 1行目で N を入力すると長さNのセグメント木を作成して適当に埋める
// 2行目以降は l r の形のクエリ（-1 -1 を入力すると終了）
import std.stdio, std.string, std.conv, std.array, std.math, std.algorithm;
import std.datetime.stopwatch, std.random;
void main(){
	int n = readln.chomp.to!int;
	auto seg = new SegTree!long(0, n, (long x, long y) => max(x, y));
	
	StopWatch sw;
	sw.start;
	foreach(i; 0 ..n) seg.setValue(i, (i + 1) * (i + 1) * (i + 1) % n);
	sw.peek.writeln;
	
	long[] ans;
	foreach(_; 0 .. n){
		/*
		int[] xs = readln.chomp.split.map!(to!int).array;
		int l = xs[0] - 1, r = xs[1];
		*/
		int i = uniform(0, n), v = uniform(0, n);
		seg.setValue(i, v);
		int l = uniform(0, n), r = uniform(0, n);
		if(l > r) continue;
		else ans ~= seg.getValue(l, r);
	}
	sw.peek.writeln;
	
	ans.sum.writeln;
	
}

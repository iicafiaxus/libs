/*
セグメント木 区分木 segtree segment tree
範囲に書き込み、1点で読み出す。
たとえば、 [l, r) の範囲に一律 x を足すクエリがくるなど。

※書き込み操作は、単位元みたいなものが存在しなければならない
（「すべての x に対して f(z, x) = f(x, z) = x」なる z ）
たとえば、+ や `max` など

引数
a, b　添字の範囲。 この意味はa から b - 1 までなので注意。
apply　(x, y) => すでに値 x があるところに y を加えるとどうなるか ※結合的な演算である必要がある
neutral　すべての x に対して apply(z, x) = apply(x, z) = x をみたす z

*/
class SegTree(T){
	T delegate(T, T) apply;
	T neutral;
	int a, b; // a <= x < b を担当する
	bool isTerminal;
	SegTree left, right; // 左の子(a <= x < c)、右の子(c <= x < b)
	T value;
	this(int a, int b, T delegate(T, T) apply, T neutral = T.init){
		this.a = a, this.b = b;
		this.apply = apply;
		this.neutral = neutral;
		this.value = neutral;
		if(b - a == 1){
			this.isTerminal = 1;
		}
		else{
			int c = (a + b) / 2;
			this.left = new SegTree(a, c, apply, neutral);
			this.right = new SegTree(c, b, apply, neutral);
		}
	}
	
	// [a, b) に値を設定する ※[a, b) はこのノードの担当区間とかぶっていなくてもよい
	void setValue(int a, int b, T value){
		if(b <= this.a || this.b <= a) return;
		if(a <= this.a && this.b <= b){
			this.value = apply(this.value, value);
		}
		else{
			divideValue();
			left.setValue(a, b, value);
			right.setValue(a, b, value);
		}
	}
	
	// 自分の持っていた値を子に引き継ぐ
	void divideValue(){
		left.value = apply(left.value, this.value);
		right.value = apply(right.value, this.value);
		this.value = neutral;
	}
	
	// iにおける値 ※iは必ずこのノードの担当区間内である前提
	T getValue(int i){
		assert(a <= i && i < b);
		if(this.isTerminal) return this.value;
		else divideValue();
		if(i < left.b) return left.getValue(i);
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
		if(this.isTerminal) return this.array.to!string;
		else{
			string[] l = left.toString.split("\n"), r = right.toString.split("\n");
			while(l.length < r.length) l ~= l[$ - 1].map!(x => " ").join;
			while(l.length > r.length) r ~= r[$ - 1].map!(x => " ").join;
			string[] res = [this.array.to!string];
			foreach(i; 0 .. l.length) res ~= l[i] ~ r[i];
			return res.join("\n");
		}
	}
}

// テストコード
// 1行目で N を入力すると長さNのセグメント木を作成して初期化
// 2行目以降は、0 l r x の形のクエリ（l から r までの範囲にx を書き込む）か
// 1 i の形のクエリ（i を読み出す）
import std.stdio, std.string, std.conv, std.array, std.math, std.algorithm;
void main(){
	int n = readln.chomp.to!int;
	auto seg = new SegTree!long(0, n, (long x, long y) => x + y, 0);
	
	while(1){
		int[] xs = readln.chomp.split.map!(to!int).array;
		if(xs[0] == 0){
			int l = xs[1] - 1, r = xs[2], x = xs[3];
			if(l < 0) break;
			else seg.setValue(l, r, x);
			//seg.writeln;
		}
		else{
			int i = xs[1] - 1;
			seg.getValue(i).writeln;
			//seg.writeln;
		}
	}
	
}

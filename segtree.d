/*
セグメント木 区分木 segtree segment tree

1点に書き込み、範囲で読み出す。(単位元の存在を仮定)
たとえば [l, r) の最大値を求めるなど。

使い方

準備
	auto seg = new SegTree!(
		long,
			// 値の型
		delegate (long x, long y) => x + y,
			// 左の子と右の子から自分の値をきめる関数（たとえばmax）
		0
			// すべての x に対して merge(x, z) = x をみたすz（たとえば-infty）
			// 配列はこの値で初期化される
	)(a, b);
		// 添字の範囲。 この意味は a 以上 b - 1 以下ということ
    
書き込み
	seg.setValue(i, x);
		// 添字 i の位置に値 x をセットする

読み出し
	long ans = seg.getValue(a, b)
		// a 以上 b - 1 以下の部分についての計算結果

テストコード
	AOJ DSL_2_A
	https://paiza.io/projects/e/52K1iUD5pHv0OES3Sle14Q

*/
class SegTree(
	T,
	T delegate(T, T) merge,
	T neutral
){
	int a, b; // a <= x < b を担当する
	SegTree left, right; // 左の子(a <= x < c)、右の子(c <= x < b)
	T value;
	bool hasValue;
	bool isTerminal;
	this(int a, int b){
		this.a = a, this.b = b;
		if(b - a == 1){
    		this.value = neutral;
    		this.hasValue = 1;
			this.isTerminal = 1;
		}
		else{
			int c = (a + b) / 2;
			this.left = new SegTree(a, c);
			this.right = new SegTree(c, b);
		}
	}
	
	// [a, b) における値を読む ※[a, b) はこのノードの担当区間とかぶっていなくてもよい
	T getValue(){ return getValue(a, b); }
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

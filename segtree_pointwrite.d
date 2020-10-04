/*
セグメント木 区分木 segtree segment tree

1点に書き込み、範囲で読み出す。
たとえば [l, r) の和を求めるなど。
(書き込みはべき等でなくてもよく、単位元もなくてよい)

使い方

準備
	auto seg = new SegTree!(
		long, long,
			// 与える値の型と、計算結果の型
		delegate (long x, long v) => x + v,
			// 計算結果が x である区間に値 v を与えたら、この区間の計算結果はどうなるか
		delegate (long x, long y) => x + y,
			// 計算結果が x である区間と y である区間をつなげたら、計算結果はどうなるか
		0
			// 計算結果の初期値 (起動直後に1点を読み出すとこの値が出てくる)
	)(a, b);
		// 添字の範囲。 この意味は a 以上 b - 1 以下ということ
    
書き込み
	seg.setValue(i, x);
		// 添字 i の位置に値 x を与える

読み出し
	long ans = seg.getValue(a, b)
        	// a 以上 b - 1 以下の部分についての計算結果

テストコード
	AOJ DSL_2_B
	https://paiza.io/projects/e/DiEmVCszplumS4a_BntLRQ

*/
class SegTree(
	U, T, 
	T delegate(T, U) apply,
	T delegate(T, T) merge,
	T initial
){
	int a, b; // a <= x < b を担当する
	SegTree left, right; // 左の子(a <= x < c)、右の子(c <= x < b)
	T result;
	bool hasResult;
	bool isTerminal;
	this(int a, int b){
		this.a = a, this.b = b;
		if(b - a == 1){
			this.isTerminal = 1;
    		this.result = initial;
			this.hasResult = 1;
		}
		else{
			int c = (a + b) / 2;
			this.left = new SegTree(a, c);
			this.right = new SegTree(c, b);
		}
	}
	
	// [a, b) における計算結果を読む
	// ※[a, b) はこのノードの担当区間とかぶっていなければならない
	T getResult(){ return getResult(a, b); }
	T getResult(int a, int b){
		assert(this.a < b && a < this.b);
		if(a <= this.a && this.b <= b){
		    if( ! hasResult){
    		    T x = left.getResult(), y = right.getResult();
    		    this.result = merge(x, y);
    			this.hasResult = 1;
    		}
			return this.result;
		}
		else{
		    if(a < left.b && right.a < b){
		        T x = left.getResult(a, b), y = right.getResult(a, b);
		        return merge(x, y);
		    }
		    else if(a < left.b) return left.getResult(a, b);
		    else if(right.a < b) return right.getResult(a, b);
		    assert(0);
		}
	}

	// i に値を設定
	void setValue(int i, T value){
		assert(a <= i && i < b);
		if(isTerminal){
		    result = apply(result, value);
		}
		else{
		    if(i < left.b) left.setValue(i, value);
		    else right.setValue(i, value);
		    hasResult = 0;
		}
	}
	
	// 配列に変換したもの（デバッグ用）
	T[] array(){
		if(this.isTerminal) return [this.result];
		else return this.left.array ~ this.right.array;
	}
	
	// 文字列に変換したもの（デバッグ用）
	override string toString(){
		return this.array.to!string;
	}
}

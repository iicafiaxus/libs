// 重みつきの場合と重みなしの場合を別々に実装しています。

/*
------------------------------------------------------------
	ダイクストラ法
	(辺の重みは任意の正の整数)

	使い方
	auto dij = new Dijkstra(n);
		// 頂点数 n
	dij.makeArrow(i, j, cost);
		// 頂点 i から頂点 j へコスト cost の辺を張る
		// (頂点の番号は 0 始まり)
	dij.root = s;
		// 頂点 s をスタート地点とする
		// デフォルトは 0
	long v = dij(t);
		// 頂点 t までの距離を求める ※到達不能は -1
		// 初回は計算をするので O(V + E log E)
		// 2回目以降は O(1)

	テスト
		AOJ: GRL 1A
		http://judge.u-aizu.ac.jp/onlinejudge/review.jsp?rid=4958384
------------------------------------------------------------
*/ 
class Dijkstra{
	int n;
	long[int][] cost;
	long[] result;
	int _root;
	bool hasResult;
	this(int n){
		this.n = n;
		cost = new long[int][](n);
		result = new long[](n);
	}
	void makeArrow(int i, int j, long value){
		// assert(i >= 0 && i < n && j >= 0 && j < n);
		if(i == j) return;
		if(j !in cost[i] || cost[i][j] > value) cost[i][j] = value;
		hasResult = 0;
	}
	void connect(int i, int j, long value){
		makeArrow(i, j, value);
		makeArrow(j, i, value);
	}
	int root(int r){
		// assert(r >= 0 && r < n);
		_root = r;
		hasResult = 0;
		return _root;
	}
	int root(){
		return _root;
	}
	long opCall(int i){
		// assert(i >= 0 && i < n);
		if( ! hasResult) calc;
		return result[i];	   
	}
	struct X{ int id; long value; }
	void calc(){
		foreach(i; 0 .. n) result[i] = -1;
		auto uh = new RedBlackTree!(X, "a.value<b.value", true);
		uh.insert(X(root, 0));
		while( ! uh.empty){
			auto u = uh.front;
			uh.removeFront;
			int i = u.id;
			log("root:", root, "i:", i, "v:", u.value);
			if(result[i] >= 0) continue;
			result[i] = u.value;
			foreach(j, c; cost[i]){
				if(result[j] >= 0) continue;
				uh.insert(X(j, result[i] + cost[i][j]));
			}
		}
		hasResult = 1;
	}   
}


/*
------------------------------------------------------------
	ダイクストラ法
	(辺の重みがすべて 0 か 1 である場合)
	使い方
	auto dij = new Dijkstra(n);
		// 頂点数 n
	dij.makeArrow(i, j);
		// 頂点 i から頂点 j へコスト 1 の辺を張る
		// (頂点の番号は 0 始まり)
	dij.makeZeroArrow(i, j);
		// 頂点 i から頂点 j へコスト 0 の辺を張る
		// (頂点の番号は 0 始まり)
	dij.root = s;
		// 頂点 s をスタート地点とする
		// デフォルトは 0
	long v = dij(t);
		// 頂点 t までの距離を求める ※到達不能は -1
		// 初回は計算をするので O(E + V)
		// 2回目以降は O(1)
------------------------------------------------------------		
*/ 
class Dijkstra{
	int n;
	int[][] zeronodes;
	int[][] onenodes;
	long[] result;
	int _root;
	bool hasResult;
	this(int n){
		this.n = n;
		onenodes = new int[][](n);
		zeronodes = new int[][](n);
		result = new long[](n);
	}
	void makeArrow(int i, int j){
		// assert(i >= 0 && i < n && j >= 0 && j < n);
		if(i == j) return;
		onenodes[i] ~= j;
		hasResult = 0;
	}
	void makeZeroArrow(int i, int j){
		// assert(i >= 0 && i < n && j >= 0 && j < n);
		if(i == j) return;
		zeronodes[i] ~= j;
		hasResult = 0;
	}
	int root(int r){
		// assert(r >= 0 && r < n);
		_root = r;
		hasResult = 0;
		return _root;
	}
	int root(){
		return _root;
	}
	long opCall(int i){
		// assert(i >= 0 && i < n);
		if( ! hasResult) calc;
		return result[i];	   
	}
	struct X{ int id; long value; }
	void calc(){
		foreach(i; 0 .. n) result[i] = -1;
		auto zeroq = new Queue!X, uq = new Queue!X;
		uq ~= X(root, 0);
		while( ! zeroq.isEmpty || ! uq.isEmpty){
			auto u = zeroq.isEmpty ? uq.pop : zeroq.pop;
			int i = u.id;
			if(result[i] >= 0) continue;
			result[i] = u.value;
			foreach(j; zeronodes[i]){
				if(result[j] >= 0) continue;
				zeroq ~= X(j, result[i]);
			}
			foreach(j; onenodes[i]){
				if(result[j] >= 0) continue;
				uq ~= X(j, result[i] + 1);
			}
		}
		hasResult = 1;
	}   
}
// ----- キュー -----
class Queue(T){
	private T[] xs;
	private uint i, j; // i : 次に読み出す位置　j: 次に書き込む位置
	this(){	}
	this(T[] xs){ this.xs = xs; j = xs.length.to!uint; }
	uint length(){ return j - i; }
	bool isEmpty(){ return j == i; }
	alias empty = isEmpty;
	void enq(T x){
		while(j + 1 >= xs.length) xs.length = xs.length * 2 + 1;
		xs[j ++] = x;
	}
	T deq(){ assert(i < j); return xs[i ++]; }
	T peek(){ assert(i < j); return xs[i]; }
	alias pop = deq, push = enq, top = peek;
	Queue opOpAssign(string op)(T x){
		if(op == "~"){ enq(x); return this; }
		assert(0, "Operator " ~ op ~ "= not implemented");
	}
	T opIndex(uint li){ assert(i + li < j); return xs[i + li]; }
	static Queue!T opCall(){ return new Queue!T; }
	static Queue!T opCall(T[] xs){ return new Queue!T(xs); }
	T[] array(){ return xs[i .. j]; }
	override string toString(){ return array.to!string; }
}

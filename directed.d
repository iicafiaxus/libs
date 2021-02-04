/*
有向グラフ
隣接リスト方式で持っているのでメモリは辺の本数に比例

使い方
	初期化
	auto dir = new Directed(n);
	
	辺の設置
	dir.makeArrow(i, j); // 添字は0から始まる
　
	ループ判定 
	if(dir.hasLoop) "Yes".print; // ループがあるとき真を返す

	トポロジカルソート　※ループがある場合は対応外
	int[] us = dir.topsorted; // ソートされた添字列(0始まり)の1つを返す

*/
class Directed{
	int n;
	int[][] kids;
	int[][] parents;
	this(int n){
		this.n = n;
		kids = new int[][](n);
		parents = new int[][](n);
	}
	void makeArrow(int a, int b){
		kids[a] ~= b;
		parents[b] ~= a;
	}
	int incount(int i){
		return parents[i].length.to!int;
	}
	int outcount(int i){
		return kids[i].length.to!int;
	}

	/*
		有向グラフとしてのループを検出
		（分岐からの再合流はループではない）
	*/
	bool hasLoop(){
		int[] fs = new int[](n);
			// -1=エラー 0=未処理 1=処理中 2=処理済み
		
		void calc(int i){
			if(fs[i] == 0){
				fs[i] = 1;
				foreach(j; kids[i]) calc(j);
				if(fs[i] == 1) fs[i] = 2;
			}
			else if(fs[i] == 1) fs[i] = -1;
			else return;
		}

		foreach(i; 0 .. n) if(parents[i].length == 0) calc(i);

		foreach(i; 0 .. n) if(fs[i] < 2) return 1;
		return 0;
	}

	/*
		トポロジカルソート
		逆行する辺がないようにソートされた添字の列を1つ返す
		そのようなものが存在しないとき(ループのとき)は対応外
	*/
	int[] topsorted(){
		int[] res;
		int[] xs = new int[](n);
		foreach(i; 0 .. n) xs[i] = parents[i].length.to!int;

		int[] q;
		int ix;
		foreach(i; 0 .. n) if(parents[i].length == 0) q ~= i;

		while(ix < q.length){
			int i = q[ix];
			ix += 1;
			res ~= i;
			foreach(j; kids[i]){
				xs[j] -= 1;
				if(xs[j] == 0) q ~= j;
			}
		}

		return res;
	}
}

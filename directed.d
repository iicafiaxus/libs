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

	強連結成分分解
	dir.scc;

	強連結成分の代表ノード　※先に強連結成分分解をすること
	int si = dir.strong[i]; // ノードiが属する強連結成分の代表ノードの番号

	強連結成分からなるグラフ　※先に強連結成分分解をすること
	auto d = dir.dag; // 辺を代表ノードにつなぎ直して新しく作ったグラフ
		// 番号はズレない。そのため不要なノード（代表ノードではないノード）が存在している
		// 「孤立ノード=ゴミ」ではないので注意（孤立した強連結成分の場合もあるため）
		// ゴミではないことの判定は i == strong[i]
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
		強連結成分分解
	*/
	int[] strong; // 強連結成分の代表ノード
	int[][] sccmembers; // 強連結成分に含まれるノードたち
	Directed dag;
		// 辺を代表ノードにつなぎ直した有向グラフ
		// （代表ノードでないノードもそのまま孤立点として含まれている）
	void scc(){
		strong = new int[](n);
		dag = new Directed(n);
		sccmembers = new int[][](n);
		
		int[] fs = new int[](n);
			// 0=未処理 1=処理済(calc1) 2=処理済(calc2)

		int[] us;
		
		void calc1(int i){
			if(fs[i] == 0){
				fs[i] = 1;
				foreach(j; kids[i]) calc1(j);
				us ~= i;
			}
			else return;
		}

		foreach(i; 0 .. n) calc1(i);

		void calc2(int u, int i){
			if(fs[i] == 1){
				strong[i] = u, sccmembers[u] ~= i;
				fs[i] = 2;
				foreach(j; parents[i]) calc2(u, j);
			}
			else return;
		}

		foreach_reverse(u; us) calc2(u, u);

		foreach(i; 0 .. n) foreach(j; kids[i]){
			if(strong[i] != strong[j]) dag.makeArrow(strong[i], strong[j]);
		}

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

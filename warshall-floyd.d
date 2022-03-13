/*
  ワーシャルフロイト法
  計算量はn³
  
  使い方
	auto wf = new WF(n);
	foreach(ed; eds) wf.connect(ed.x, ed.y, ed.cost);
  
  ※connectは双方向
  　makeArrowは一方通行
   
  wf(i, j) でiからjまでの距離が得られる
  ※初めて呼び出したときに計算をしてそれ以降はキャッシュから返す
  ※後から辺を追加することも可能（その場合はキャッシュは消える）

*/

class WF{
	int n;
	long[][] cost;
	bool[][] isValid;
	bool hasResult;
	this(int n){
		this.n = n;
		cost = new long[][](n, n);
		isValid = new bool[][](n, n);
	}
	void connect(int i, int j, long value){
		makeArrow(i, j, value);
		makeArrow(j, i, value);
	}
	void makeArrow(int i, int j, long value){
		cost[i][j] = value;
		isValid[i][j] = 1;
		hasResult = 0;
	}
	long opCall(int i, int j){
		if( ! hasResult) calc;
		return cost[i][j];
	}
	void calc(){
		isLong = new bool[][](n, n);
		foreach(i; 0 .. n){
			cost[i][i] = 0;
			isValid[i][i] = 1;
		}
		foreach(k; 0 .. n) foreach(i; 0 .. n) foreach(j; 0 .. n){
			if(k == i || k == j || i == j) continue;
			if(isValid[i][k] && isValid[k][j]){
				if( ! isValid[i][j] || cost[i][j] >= cost[i][k] + cost[k][j]){
					cost[i][j] = cost[i][k] + cost[k][j];
					isValid[i][j] = 1;
				}
			}
		}
		hasResult = 1;
	}   
}

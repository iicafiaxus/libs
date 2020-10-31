/*
    ダイクストラ法

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
        // 頂点 t までの距離を求める
        // 初回は計算をするので O(E log E)
        // 2回目以降は O(1)

    テスト
        AOJ: GRL 1A
        http://judge.u-aizu.ac.jp/onlinejudge/review.jsp?rid=4958384

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
        cost[i][j] = value;
        hasResult = 0;
    }
    void makeArrow(int i, int j){
        makeArrow(i, j, 1);
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

/*
    テスト用のグラフを作成

    使い方
    auto ps = generatedEdges(n, n * n, 80, 80, 100, 0, true, false, false);
    foreach(p; ps) print(p.u + 1, p.v + 1);

*/
struct GeneratorEdge{ int u, v; }
GeneratorEdge[] generatedEdges(
    int n, // 頂点数
    int m, // 辺数の上限
    int r1, // 全体が連結になった後、辺追加を続行する確率(%)
    int r2, // 1つの連結成分内で完結する辺を捨てずに使う確率(%)
    int r3, // 全体が連結になっていないとき、辺追加を続行する確率(%)
    int r4, // 辺数の上限に達した後、辺追加を続行する確率(%)
    bool allowInverted, // 逆向きの辺（u > v）を許可する
    bool allowMultiple, // 多重辺を許可する
    bool allowSelfLoop, // 自己ループを許可する

    GeneratorEdge[] res;

    auto uf = new UnionFind(n);
    bool[int[2]] cnt;
    while(uniform(0, 100) >= r3){
        int u = uniform(0, n);
        int v = uniform(0, n);
        if( ! allowInverted && u > v) swap(u, v);
        if( ! allowSelfLoop && u == v) continue;
        if( ! allowMultiple && [u, v] in cnt) continue;
        if(uf.find(u) == uf.find(v) && uniform(0, 100) >= r2) continue;
        uf.unite(u, v);
        cnt[[u, v]] = 1, cnt[[v, u]] = 1;
        res ~= GeneratorEdge(u, v);
        if(res.length >= m && uniform(0, 100) >= r4) break;
        if(uf.getSize(0) >= n && uniform(0, 100) >= r1) break;
    }

    return res;
}

/*
木
今は根からの深さを求めるしかできないが追い追い整備する
lca.d にも関係する機能が入っているのでいずれ合流するかも

使用例
    int n = scan!int;
    auto graph = new Graph(n);
    foreach(i; 0 .. n - 1){
        int u = scan!int - 1, v = scan!int - 1;
        graph.connect(u, v);
    }
    graph.root = 0;
    graph.setDepth;
    foreach(nd; graph.nodes) nd.depth.print;

思想として、全部入りにするので、必要な機能を明示的に呼ぶ
(rootを定めただけで自動的にsetDepthが行われたりはしない)
(明示的ではなくても、例えばdepthにアクセスしようとしたとき
まだsetDepthしてなかったら呼ばれるとかでもよいかも)

*/
class Graph{
    int n;
    Node _root;
    bool hasRoot;
    Node[] nodes;
    Edge[] edges;
    this(int n){
        this.n = n;
        foreach(i; 0 .. n) nodes ~= new Node(i);
    }
    void connect(int i, int j){
        edges ~= new Edge(nodes[i], nodes[j]);
    }
    Node root(){
        return _root;
    }
    int root(int i){
        root = nodes[i];
        return i;
    }
    Node root(Node nd){
        hasRoot = 1;
        return _root = nd;
    }
    void setDepth(){
        assert(hasRoot);
        foreach(nd; nodes) nd.hasDepth = 0;
        root.setDepth(0);
    }
}
class Node{
    int id;
    int depth;
    bool hasDepth;
    Edge[] edges;
    Node[] nodes;
    this(int id){
        this.id = id;
    }
    void setDepth(int d){
        depth = d;
        hasDepth = 1;
        foreach(nd; nodes){
            if( ! nd.hasDepth) nd.setDepth(d + 1);
        }
    }
}
class Edge{
    Node node0, node1;
    this(Node node0, Node node1){
        this.node0 = node0, this.node1 = node1;
        node0.nodes ~= node1, node1.nodes ~= node0;
            // 重複辺や自己ループは考慮していない
    }
}

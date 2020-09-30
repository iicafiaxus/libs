/*
    最小費用流
    使い方

    初期化
        auto costflow = new CostFlow(n);
            // n 個の頂点 (SとTは別途用意される)
    
    辺を作る
        costflow.connect(i, j, capacity, cost); 
            // 頂点 i から頂点 j へ、容量 capacity でコスト単価 cost の辺を作る
            // cost は 0 以上とすること
    
    湧き出し頂点を作る
        costflow.setSource(i, capacity, cost);
            // 頂点 i を容量 capacity でコスト単価 cost の湧き出し頂点とする
            // (= S から頂点 i への辺を作る)
    
    吸い込み頂点を作る
        costflow.setSink(i, capacity, cost);
            // 頂点 i を容量 capacity でコスト単価 cost の吸い込み頂点とする
            // (= 頂点 i から T への辺を作る)

    結果を求める
        auto ans = costflow.getResult(flow);
            // (long) ans.value　流量 flow を流すときの最小のコスト
            // (bool) ans.isError　流量 flow を流しきれなかったとき真
            // ※ 流しきれなかったときは ans.value の値は不定

*/
class CostFlow{
    int n;
    Node[] nodes, allNodes;
    Edge[] edges, allEdges;
    Node source, sink;
    this(int n){
        this.n = n;
        foreach(i; 0 .. n) new Node;
        source = new Node, sink = new Node;
    }
    void connect(int i, int j, long v, long c){
        new Edge(i, j, v, c);
    }
    void setSource(int j, long v, long c){
        new Edge(source.id, j, v, c);
    }
    void setSink(int i, long v, long c){
        new Edge(i, sink.id, v, c);
    }
    struct Result{ long value; bool isError; }
    Result getResult(long k){
        long cost;
        long maxcost;
        foreach(ed; edges) maxcost += max(ed.cost, 0);
        while(k > 0){
            foreach(nd; nodes) nd.parentEdge = null, nd.value = k, nd.cost = maxcost + 1;
            source.cost = 0;
            long f = getBest(k);
            if(f == 0) return Result(0, 1);
            for(Node nd = sink; nd.id != source.id; nd = nd.parentEdge.node0){
                nd.parentEdge.value -= f;
                nd.parentEdge.inv.value += f;
                cost += nd.parentEdge.cost * f;
            }
            k -= f;
        }
        return Result(cost, 0);
    }
    long getBest(long value){
        struct S{ int id; long value; }
        auto ndh = new RedBlackTree!(S, "a.value < b.value", true);
        ndh.insert(S(source.id, source.cost));
        while( ! ndh.empty){
            Node nd = nodes[ndh.front.id];
            ndh.removeFront;
            foreach(ed; nd.edges){
                if(ed.value > 0){
                    Node nd1 = ed.node1;
                    if(nd1.cost > nd.cost + ed.cost){
                        nd1.cost = nd.cost + ed.cost;
                        nd1.parentEdge = ed;
                        nd1.value = min(nd.value, ed.value);
                        ndh.insert(S(nd1.id, nd1.cost));
                    }
                }
            }
        }
        if(sink.parentEdge) return sink.value;
        else return 0;
    }

    class Node{
        int id;
        Edge[] edges;
        long value, cost;
        Edge parentEdge;
        this(){
            this.id = nodes.length.to!int;
            nodes ~= this;
        }
        override string toString(){
            return id.to!string ~ "(" ~ value.to!string ~ "@" ~ cost.to!string ~ ")"
                ~ (parentEdge? "<" ~ parentEdge.node0.id.to!string: "");
        }
    }
    class Edge{
        Edge inv;
        Node node0, node1;
        long value;
        long cost;
        this(int i, int j, long v, long c, bool isInv = 0){
            this.node0 = nodes[i], this.node1 = nodes[j];
            this.value = v, this.cost = c;
            allEdges ~= this;

            if(! isInv){
                this.inv = new Edge(j, i, 0, -c, 1);
                this.inv.inv = this;
                edges ~= this;
                node0.edges ~= this;
                node1.edges ~= this.inv;
            }
        }
        override string toString(){
            return node0.id.to!string ~ "-" ~ node1.id.to!string
                 ~ "(" ~ value.to!string ~ "/" ~ inv.value.to!string ~ ")"
                 ~ "@" ~ cost.to!string;
        }
    }

    override string toString(){
        return "Nodes: " ~ nodes.map!(nd => nd.toString).array.join(" ")
            ~ "\n" ~ "Edges: " ~ edges.map!(ed => ed.toString).array.join(" ");
    }
}

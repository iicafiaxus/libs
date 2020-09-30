/*
    最大流 (Dinic法)

    使い方

        auto dinic = new Dinic(n);
            // n 個の頂点からなる

        foreach(_; 0 .. m) dinic.connect(a, b, c); 
            // 頂点 a から頂点 b に容量 c の辺をはる
            // 番号は 0 から始まる
            // c は 0 以上であること

        long ans = dinic.getResult(s, t);
            // 頂点 s から頂点 t への最大流
            // 番号は 0 から始まる
    
    計算量は O(n²m)
    
*/
class Dinic{
    int n;
    Node[] nodes;
    Edge[] edges;
    this(int n){
        this.n = n;
        foreach(i; 0 .. n) new Node;
    }
    void connect(int i, int j, long v){
        Edge edge = new Edge(i, j, v);
        Edge inv = new Edge(j, i, 0, 1);
        edge.inv = inv, inv.inv = edge;
        nodes[i].edges ~= edge;
        nodes[j].edges ~= inv;
    }
    long getResult(int i, int j){
        Node source = nodes[i], target = nodes[j];
        long maxflow;
        foreach(ed; edges) maxflow += ed.value;
        long res;
        while(1){
            log("flow:", res);
            foreach(nd; nodes) nd.depth = -1, nd.isVisited = 0;
            setDepth(source);
            if( ! target.isVisited) break;
            foreach(ed; edges) ed.isAlive = (ed.value > 0 && ed.node1.depth - ed.node0.depth == 1);
            res += doFlow(source, target, maxflow);
        }
        return res;
    }
    void setDepth(Node src){
        Node[] ndq = [src];
        int ix = 0;
        foreach(nd; nodes) nd.depth = n;
        src.depth = 0;
        while(ix < ndq.length){
            Node nd = ndq[ix ++];
            if(nd.isVisited) continue;
            nd.isVisited = 1;
            foreach(ed; nd.edges){
                if(ed.value == 0) continue;
                Node nd1 = ed.node1;
                if(nd1.depth > nd.depth + 1){
                    nd1.depth = nd.depth + 1;
                    ndq ~= nd1;
                }
            }
        }
    }
    long doFlow(Node nd, Node tar, long value){
        if(nd.id == tar.id) return value;
        long doneValue;
        foreach(ed; nd.edges){
            if( ! ed.isAlive) continue;
            Node nd1 = ed.node1;
            long f = doFlow(nd1, tar, min(value - doneValue, ed.value));
            if(f > 0){
                ed.value -= f, ed.inv.value += f;
                if(ed.value == 0) ed.isAlive = 0;
            }
            else{
                ed.isAlive = 0;
            }
            doneValue += f;
            if(doneValue == value) break;
        }
        return doneValue;
    }
    class Node{
        int id;
        Edge[] edges;
        int depth;
        bool isVisited;
        this(){
            this.id = nodes.length.to!int;
            nodes ~= this;
        }
        override string toString(){
            return id.to!string ~ "(" ~ depth.to!string ~ ")";
        }
    }
    class Edge{
        Edge inv;
        bool isInv;
        Node node0, node1;
        long value;
        bool isAlive;
        this(int i, int j, long v, bool isInv = 0){
            this.node0 = nodes[i];
            this.node1 = nodes[j];
            this.value = v;
            this.isInv = isInv;
            edges ~= this;
        }
        override string toString(){
            return node0.id.to!string ~ "-" ~ node1.id.to!string
                 ~ "(" ~ (isAlive? "": "x") ~ value.to!string ~ "/" ~ (inv.isAlive? "": "x") ~ inv.value.to!string ~ ")";
        }
    }

    override string toString(){
        return "Nodes: " ~ nodes.map!(nd => nd.toString).array.join(" ")
            ~ "\n" ~ "Edges: " ~ edges.filter!(ed => ! ed.isInv).map!(ed => ed.toString).array.join(" ");
    }
}

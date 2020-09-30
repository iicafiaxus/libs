/*
    最小費用流

*/
class CostFlow{
    int n;
    Node[] nodes;
    Edge[] edges;
    this(int n){
        this.n = n;
        foreach(i; 0 .. n) new Node;
    }
    void connect(int i, int j, long v, long c){
        Edge edge = new Edge(i, j, v, c);
        Edge inv = new Edge(j, i, 0, -c, 1);
        edge.inv = inv, inv.inv = edge;
        nodes[i].edges ~= edge;
        nodes[j].edges ~= inv;
    }
    struct Result{ long value; bool isError; }
    Result getResult(int i, int j, long k){
        Node source = nodes[i], target = nodes[j];
        long cost;
        long maxcost;
        foreach(ed; edges) maxcost += max(ed.cost, 0);
        log(this);
        while(k > 0){
            foreach(nd; nodes) nd.parentEdge = null, nd.value = k, nd.cost = maxcost + 1, nd.isVisited = 0;
            source.cost = 0;
            long f = getBest(source, target, k);
            if(f == 0) return Result(0, 1);
            for(Node nd = target; nd.id != source.id; nd = nd.parentEdge.node0){
                nd.parentEdge.value -= f;
                nd.parentEdge.inv.value += f;
                cost += nd.parentEdge.cost * f;
            }
            k -= f;
            log("flow this time:", f, "flow left:", k, "cost:", cost);
            log(this);
            if(f == 0) return Result(0, 1);
        }
        return Result(cost, 0);
    }
    long getBest(Node src, Node tar, long value){
        struct S{ int id; long value; }
        auto ndh = new RedBlackTree!(S, "a.value < b.value", true);
        ndh.insert(S(src.id, src.cost));
        while( ! ndh.empty){
            Node nd = nodes[ndh.front.id];
            ndh.removeFront;
            foreach(ed; nd.edges){
                if(ed.value > 0){
                    Node nd1 = ed.node1;
                    if(nd1.cost > nd.cost + ed.cost){
                        log("nd:", nd, "nd1:", nd1, "ed:", ed, "cost:", nd.cost + ed.cost);
                        nd1.cost = nd.cost + ed.cost;
                        nd1.parentEdge = ed;
                        nd1.value = min(nd.value, ed.value);
                        ndh.insert(S(nd1.id, nd1.cost));
                    }
                }
            }
        }
        if(tar.parentEdge) return tar.value;
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
        bool isInv;
        Node node0, node1;
        long value;
        long cost;
        this(int i, int j, long v, long c, bool isInv = 0){
            this.node0 = nodes[i];
            this.node1 = nodes[j];
            this.value = v;
            this.cost = c;
            this.isInv = isInv;
            edges ~= this;
        }
        override string toString(){
            return node0.id.to!string ~ "-" ~ node1.id.to!string
                 ~ "(" ~ value.to!string ~ "/" ~ inv.value.to!string ~ ")"
                 ~ "@" ~ cost.to!string;
        }
    }

    override string toString(){
        return "Nodes: " ~ nodes.map!(nd => nd.toString).array.join(" ")
            ~ "\n" ~ "Edges: " ~ edges.filter!(ed => ! ed.isInv).map!(ed => ed.toString).array.join(" ");
    }
}

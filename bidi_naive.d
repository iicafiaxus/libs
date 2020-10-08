// 双方向木DP (簡易版)
// 下り方向も上り方向と同じ計算方法でOKなタイプ
class BidiTree(
    T, // 辺のもつデータ型
    T delegate (T[] vs) calcNaive,
        // 1つ以外全ての入り辺のデータから1つの出辺のデータを計算する
        // （inedges には求める出辺の逆辺のデータは含まれていない）
    T initial
){
    int n;
    Node[] nodes;
    Edge[] edges;
    this(int n){
        this.n = n;
        foreach(i; 0 .. n) new Node;
    }
    void connect(int a, int b){
        new Edge(a, b);
    }
    void calc(){
        nodes[0].calc;
    }
    class Node{
        int id;
        Edge[] inedges, edges;
        this(){
            id = nodes.length.to!int;
            nodes ~= this;
        }
        void calc(){
            foreach(ed; inedges) ed.calcUp;
            foreach(ed; edges) ed.calcDown;
        }
        override string toString(){
            return id.to!string;
        }
    }
    class Edge{
        T value;
        int id;
        Edge inv;
        bool isInv;
        Node node0, node1;
        this(int a, int b, bool isInv = 0){
            node0 = nodes[a], nodes[a].edges ~= this;
            node1 = nodes[b], nodes[b].inedges ~= this;
            id = edges.length.to!int;
            edges ~= this;
            this.isInv = isInv;
            value = initial;

            if(isInv) return;
            Edge inv = new Edge(b, a, 1);
            this.inv = inv;
            inv.inv = this;
        }
        T calcUp(){
            log(this, "calcUp");
            auto inedges = node0.inedges.filter!(ed => ed.inv.id != id);
            T[] vs;
            foreach(ed; inedges) vs ~= ed.calcUp();
            value = calcNaive(vs);
            log("calcUp", this);
            return value;
        }
        void calcDown(){
            log(this, "calcDown");
            // 簡易版
            auto inedges = node0.inedges.filter!(ed => ed.inv.id != id);
            T[] vs;
            foreach(ed; inedges) vs ~= ed.value;
            value = calcNaive(vs);
            auto edges = node1.edges.filter!(ed => ed.inv.id != id);
            foreach(ed; edges) ed.calcDown;
            log("calcDown", this);
        }
        override string toString(){
            return id.to!string ~ "(" ~ node0.id.to!string ~ "-" ~ node1.id.to!string ~ ")" ~ value.to!string;
        }
    }
    override string toString(){
        return "Nodes: " ~ nodes.map!(nd => nd.toString)().array.join(" ") ~ "\n"
            ~ "Edges: " ~ edges.map!(ed => ed.toString)().array.join(" ");
    }
}

// 双方向木DP (正式版)
// 上り方向と下り方向を別々の方法で計算する
// ※下り方向が総和からの引き算でできるタイプしかテストされてない
// （両側からの累積和で添字を使うタイプは未チェック）
class BidiTree(
	T, // 辺のもつデータ型
	U, // 頂点のもつデータ型
	T delegate(T[]) calcNaive,
		// 1つ以外全ての入り辺のデータから1つの出辺のデータを計算する（上り用）
		// （T[] には求める出辺の逆辺のデータは含まれていないものとする）
		// O(k)
	U delegate(T[]) calcNode,
		// 全ての入り辺のデータから頂点のデータを計算する（下り用）
		// O(k)
	T delegate(int, T, U) calcEdge,
		// 頂点のデータから、k番目の出辺のデータを計算する（下り用）
		// O(1) 
	T initialEdge,
	T initialNode
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
		foreach(ed; nodes[0].inedges) ed.calcUp;
		nodes[0].calcDown;
	}
	class Node{
		U value;
		int id;
		Edge[] inedges, edges;
		this(){
			id = nodes.length.to!int;
			nodes ~= this;
			value = initialNode;
		}
		void calcDown(){
			log(this, "calcDown");
			T[] vs;
			foreach(ed; inedges) vs ~= ed.value;
			value = calcNode(vs);
			log(this, "value:", value);
			foreach(k, ed; inedges) if( ! ed.inv.hasValue){
				ed.inv.value = calcEdge(k.to!int, ed.value, value), ed.inv.hasValue = 1;
				ed.inv.calcDown();
			}
			log("calcDown", this);
		}
		override string toString(){
			return id.to!string;
		}
	}
	class Edge{
		T value;
		bool hasValue;
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
			value = initialEdge;

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
			value = calcNaive(vs), hasValue = 1;
			log("calcUp", this);
			return value;
		}
		void calcDown(){
			log(this, "calcDown");
			node1.calcDown;
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

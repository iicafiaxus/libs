// 最小共通祖先, lca, 最低共通祖先, Lowest Common Ancestor, Least Common Ancestor
// パスの長さ, 木上の距離, ツリー上の距離, ツリーでの最短経路の長さ
// ※ループがある場合や、森になっている場合は非対応
// 使い方は後のテストコードを参照

class Node{
	static Node[] all; // 存在する全てのノード
	int id;
	Node[] nodes; // 隣接ノード（親も子も含む）
	int depth; // 根は 0
	Node[] parents; // 1代前、2代前、4代前、8代前、…… の親（いない場合は打切り）
	private bool isDone;

	// 頂点を作成（根付き木は壊れる）
	this(int id){
		this.id = id;
		all ~= this;
		_root = null;
	}

	// 辺を作成（根付き木は壊れる）
	void connectTo(Node nd){
		this.nodes ~= nd, nd.nodes ~= this;
		_root = null;
	}

	// 根付き木にする（木になってない場合は未定義）
	private static Node _root;
	static Node root(){ return _root; }
	static Node root(Node r){

		// parents[0] を設定する
		foreach(nd; all) nd.isDone = 0;
		r.parents = [], r.depth = 0;
		Node[] ndq = [r];
		for(int i = 0; i < ndq.length; i ++){
			Node p = ndq[i];
			p.isDone = 1;
			foreach(q; p.nodes) if(! q.isDone){
				q.parents = [p], q.depth = p.depth + 1;
				ndq ~= q;
			}
		}

		// parents[1] 以降を設定する（30 はマジックナンバー、log(2;N) 程度）
		foreach(i; 1 .. 30) foreach(nd; all){
			if(i <= nd.parents.length){
				Node par = nd.parents[i - 1];
				if(i <= par.parents.length) nd.parents ~= par.parents[i - 1];
			}
		}

		return _root = r;
	}
	
	// 2点間の距離
	int distTo(Node nd){
		Node p = this.lca(nd);
		return (this.depth - p.depth) + (nd.depth - p.depth);
	}

	// 最小共通祖先
	Node lca(Node nd){
		assert(root);
		if(this.depth > nd.depth) return nd.lca(this);
		if(this.depth < nd.depth) foreach_reverse(p; nd.parents) if(p.depth >= this.depth) return lca(p);
		foreach_reverse(i, p; nd.parents) if(this.parents[i].id != p.id){
			return this.parents[i].lca(p);
		}
		if(this.id == nd.id) return this; else return this.parents[0];
	}
}


// ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- //

// 以下テストコード
// AOJ GRL_5_C ※この問題は添字が0始まり

import std.stdio, std.conv, std.string, std.array, std.range, std.algorithm, std.container;
import std.math, std.random, std.bigint, std.datetime, std.format;

void main(){
	int n = readln.chomp.to!int;
	Node[] nodes;
	foreach(i; 0 .. n) nodes ~= new Node(i);
	foreach(nd; nodes){
		int[] js = readln.chomp.split.to!(int[]);
		foreach(j; js[1 .. $]) nd.connectTo(nodes[j]);
	}

	Node.root = nodes[0];

	int m = readln.chomp.to!int;
	foreach(_; 0 .. m){
		int[] pq = readln.chomp.split.to!(int[]);
		nodes[pq[0]].lca(nodes[pq[1]]).id.writeln;
	}
}


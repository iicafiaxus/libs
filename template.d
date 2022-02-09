// 提出解
void solve(){
}

// ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- //
// 愚直解
void jury(){
}

// ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- //
// テストケース
void gen(){
}

// ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- //
// テンプレ
import std;
bool DEBUG = 0;
void main(string[] args){
	if(args.canFind("-debug")) DEBUG = 1;
	if(args.canFind("-gen")) gen; else if(args.canFind("-jury")) jury; else solve;
}
void log(A ...)(lazy A a){ if(DEBUG) print(a); }
void print(){ writeln(""); }
void print(T)(T t){ writeln(t); }
void print(T, A ...)(T t, A a){ stdout.write(t, " "), print(a); }
string unsplit(T)(T xs, string d = " "){ return xs.array.to!(string[]).join(d); }
string scan(){
	static string[] ss; while(!ss.length) ss = readln.chomp.split;
	string res = ss[0]; ss.popFront; return res;
}
T scan(T)(){ return scan.to!T; }
T[] scan(T)(int n){ return n.iota.map!(i => scan!T()).array; }
T mini(T)(ref T x, T y){ if(x > y) x = y; return x; }
T maxi(T)(ref T x, T y){ if(x < y) x = y; return x; }
T mid(T)(T l, T r, bool delegate(T) f){
	if( ! f(l)) return l; if(f(r - 1)) return r;
	T m; while(l < r - 1) m = (l + r) / 2, (f(m)? l: r) = m; return r;
}

// ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- //
// ライブラリ（基本）

class UnionFind{
	this(int n){ foreach(i; 0 .. n) R ~= i, K ~= [i]; } int[] R; int[][] K;
	void unite(int a, int b){
		int ra = R[a], rb = R[b]; if(ra == rb) return;
		if(K[ra].length < K[rb].length) unite(b, a);
		else foreach(k; K[rb]) R[k] = ra, K[ra] ~= k;
	}
	int find(int a){ return R[a]; }
	int getSize(int a){ return K[R[a]].length.to!int; }
}
class Queue(T){
	private T[] xs; private uint i, j;
	this(T[] xs = []){ this.xs = xs; j = xs.length.to!uint; }
	uint length(){ return j - i; }
	bool isEmpty(){ return j == i; } 
	void enq(T x){ while(j + 1 >= xs.length) xs.length = xs.length * 2 + 1; xs[j ++] = x; }
	T deq(){ assert(i < j); return xs[i ++]; }
	T peek(){ assert(i < j); return xs[i]; }
	void flush(){ i = j; }
	alias empty = isEmpty, front = peek, popFront = deq, pop = deq, push = enq, top = peek;
	Queue opOpAssign(string op)(T x) if(op == "~"){ enq(x); return this; }
	T opIndex(uint li){ assert(i + li < j); return xs[i + li]; }
	static Queue!T opCall(T[] xs){ return new Queue!T(xs); }
	T[] array(){ return xs[i .. j]; }
	override string toString(){ return array.to!string; }
}
class Stack(T){
	private T[] xs; private uint j;
	this(T[] xs = []){ this.xs = xs; j = xs.length.to!uint; }
	uint length(){ return j; }
	bool isEmpty(){ return j == 0; }
	void push(T x){ while(j + 1 >= xs.length) xs.length = xs.length * 2 + 1; xs[j ++] = x; }
	T pop(){ assert(j > 0); return xs[-- j]; }
	T peek(){ assert(j > 0); return xs[j - 1]; }
	void clear(){ j = 0; }
	alias empty = isEmpty, front = peek, popFront = pop, top = peek;
	Stack opOpAssign(string op)(T x) if(op == "~"){ push(x); return this; }
	T opIndex(uint li){ assert(j > 0 && j - 1 >= li); return xs[j - 1 - li]; }
	static Stack!T opCall(T[] xs = []){ return new Stack!T(xs); }
	T[] array(){ return xs[0 .. j]; }
	override string toString(){ return array.to!string; }
}

// ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- //
// ライブラリ（追加）


import std.conv;
/*
キュー、スタック
※優先度付きキューは Phobos の RedBlackTree を使えばよい
new RedBlackTree!(long, "a<b", true);
"a<b"は小さい要素を優先して取り出すという意味。
trueは、優先度の等しい値が複数個入ってもよいという意味。
*/

import std.conv;
// ----- キュー -----
class Queue(T){
	private T[] xs;
	private uint i, j;
	this(){	}
	this(T[] xs){ this.xs = xs; j = xs.length.to!uint; }
	uint length(){ return j - i; }
	bool isEmpty(){ return j == i; }
	alias empty = isEmpty;
	void enq(T x){
		while(j + 1 >= xs.length) xs.length = xs.length * 2 + 1;
		xs[j ++] = x;
	}
	T deq(){ assert(i < j); return xs[i ++]; }
	T peek(){ assert(i < j); return xs[i]; }
	alias pop = deq, push = enq, top = peek;
	Queue opOpAssign(string op)(T x){
		if(op == "~"){ enq(x); return this; }
		assert(0, "Operator " ~ op ~ "= not implemented");
	}
	T opIndex(uint li){ assert(i + li < j); return xs[i + li]; }
	static Queue!T opCall(){ return new Queue!T; }
	static Queue!T opCall(T[] xs){ return new Queue!T(xs); }
	T[] array(){ return xs[i .. j]; }
	override string toString(){ return array.to!string; }
}
// ----- スタック -----
class Stack(T){
	private T[] xs;
	private uint j;
	this(){	}
	this(T[] xs){ this.xs = xs; j = xs.length.to!uint; }
	uint length(){ return j; }
	bool isEmpty(){ return j == 0; }
	void push(T x){
		while(j + 1 >= xs.length) xs.length = xs.length * 2 + 1;
		xs[j ++] = x;
	}
	Stack opOpAssign(string op)(T x){
		if(op == "~"){ push(x); return this; }
		assert(0, "Operator " ~ op ~ "= not implemented");
	}
	T pop(){ assert(j > 0); return xs[-- j]; }
	T peek(){ assert(j > 0); return xs[j - 1]; }
	void clear(){ j = 0; }
	alias empty = isEmpty, top = peek;
	T opIndex(uint li){ assert(j > 0 && j - 1 >= li); return xs[j - 1 - li]; }
	static Stack!T opCall(){ return new Stack!T; }
	static Stack!T opCall(T[] xs){ return new Stack!T(xs); }
	T[] array(){ return xs[0 .. j]; }
	override string toString(){ return array.to!string; }
}


// ------ 以下テストコード ----- //

import std.stdio, std.string;
void main(){
	//auto q = new Queue!long, sta = new Stack!long;
	auto q = Queue!long([1L, 2L, 3L]), sta = Stack!long([10L, 20L, 30L]);
	writeln("\"enq %d\", \"deq\", \"push %d\", \"pop\" or \"exit\":");
	A: while(1){
		write(">");
		string[] xs = readln.chomp.split;
		long v;
		switch(xs[0]){
			case "enq":
				v = xs[1].to!long; // may err
				q.enq(v);
				break;
			case "deq":
				v = q.deq; // may err
				v.writeln;
				break;
			case "push":
				v = xs[1].to!long; // may err
				sta.push(v);
				break;
			case "pop":
				v = sta.pop; // may err
				v.writeln;
				break;
			case "exit":
				break A;
			default:
				writeln("Unknown command.");
		}
		writeln("Queue:", q, " Stack:", sta);
	}

}

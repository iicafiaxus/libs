/*
二部グラフの最大マッチング
　結果(マッチングの個数)は result に入る
　具体的なマッチング相手は match[] に入る
　　match[i] == j とは、(n個の側の) i番が (m個の側の) j番とマッチ
*/
class BipartiteMatcher{
    int n, m;
    int[][] candidates;
    int[] match;
    bool[] hasMatch;

    int _result;
    bool hasResult;

    this(int n, int m){
        this.n = n, this.m = m;
        candidates = new int[][](m, 0);
        match = new int[](n);
        hasMatch = new bool[](n);
    }
    void connect(int i, int j){
        candidates[j] ~= i;
        hasResult = 0;
    }

    int result(){
        if(! hasResult) calc;
        return _result;
    }

    int[] getPath(int j){
        auto path = new Stack!int; // 現時点での答え
        auto candis = new Stack!(int[]); // 各深さでの候補
        auto ixs = new Stack!int; // 各深さでの候補を何個見たか（=次見る添字）

        path.push(-1);
        candis.push(candidates[j]);
        ixs.push(0);

        bool[] isDone = new bool[](m);

        while(candis.length){
            log("path:", path, "candis:", candis, "ixs:", ixs);
            if(candis.peek.length == ixs.peek){
                // この深さにはもう選択肢がない
                path.pop;
                candis.pop;
                ixs.pop;
            }
            else{
                // この深さで次の選択肢を見る
                int c = candis.peek[ixs.peek];
                ixs.push(ixs.pop + 1);

                if(! hasMatch[c]){
                    // ゴールした
                    return path.array[1 .. $] ~ c;
                }

                // ゴールしていないので続きがある
                j = match[c];

                // 無限ループ防止
                if(isDone[j]) continue;
                isDone[j] = 1;

                // 次の深さへ
                path.push(c);
                candis.push(candidates[j]);
                ixs.push(0);
            }
        }

        return [];
    }

    void calc(){
        _result = 0;
        foreach(j; 0 .. m){
            log("calc", "j:", j);
            int[] us = getPath(j);
            if(us.length > 0){
                foreach_reverse(iu; 0 .. us.length - 1){
                    match[us[iu + 1]] = match[us[iu]];
                }
                match[us[0]] = j;
                hasMatch[us[$ - 1]] = 1;
                _result += 1;
            }
            log(this);
        }
        hasResult = 1;
    }

    override string toString(){
        string[] res;
        int[] invmatch = new int[](m);
        bool[] hasInvmatch = new bool[](m);
        foreach(i; 0 .. n) if(hasMatch[i]) invmatch[match[i]] = i, hasInvmatch[match[i]] = 1;
        foreach(j; 0 .. m) res ~= j.to!string ~ ": " ~ ((hasInvmatch[j])? invmatch[j].to!string: "-") ~ 
            " (" ~ candidates[j].map!(c => c.to!string).array.join(" ") ~ ")";
        return res.join("\n");
    }
}

// ----- スタック -----
class Stack(T){
	private T[] xs;
	private uint j; // j : 次に書き込む位置
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
	T opIndex(uint li){ assert(j > 0 && j - 1 >= li); return xs[j - 1 - li]; }
	static Stack!T opCall(){ return new Stack!T; }
	static Stack!T opCall(T[] xs){ return new Stack!T(xs); }
	T[] array(){ return xs[0 .. j]; }
	override string toString(){ return array.to!string; }
}

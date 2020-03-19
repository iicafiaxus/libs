// 素数位数有限体
// 負の数を与えても大丈夫（Finite(-1) などは Finite(mod - 1) の意味になる）
import std.conv;
struct Finite{
	long value; static long mod = 1_000_000_007;
	this(long v){ value = val(v); }
	static long val(long v){ return (v + mod  - (v / mod) * mod) % mod; }
	bool opCast(T: bool)(){ return value != 0; }
	bool opEquals(Finite b){ return(value == b.value); }
	string toString(){ return value.to!string; }

	Finite opUnary(string s){ long v;
		if(s == "+") v = value;
		else if(s == "-") v = mod - value;
		else if(s == "++") v = value + 1;
		else if(s == "--") v = value + mod - 1;
		else assert(0, "Operator unary " ~ s ~ " not implemented");
		return Finite(v);
	}

	Finite opBinary(string s)(Finite b){ return opBinary!s(b.value); }
	Finite opBinary(string s)(long u){ long v;
		if(s == "+") v = value + u;
		else if(s == "-") v = value + mod - u;
		else if(s == "*") v = value * u;
		else if(s == "/") v = value * inv(u);
		else assert(0, "Operator " ~ s ~ " not implemented");
		return Finite(v);
	}
	Finite opBinaryRight(string s)(long u){ long v;
		if(s == "+") v = u + value;
		else if(s == "-") v = u + mod - value;
		else if(s == "*") v = u * value;
		else if(s == "/") v = u * invvalue;
		else assert(0, "Operator " ~ s ~ " not implemented");
		return Finite(v);
	}
	Finite opAssign(long v){ value = v; return this; }

	Finite opOpAssign(string s)(Finite b){ return opOpAssign!s(b.value); }
	Finite opOpAssign(string s)(long v){
		if(s == "+") value = (value + v) % mod;
		else if(s == "-") value = (value + mod - v) % mod;
		else if(s == "*") value = (value * v) % mod;
		else if(s == "/") value = (value * inv(v)) % mod;
		else assert(0, "Operator " ~ s ~ "= not implemented");
		return this;
	}
	
	private static long[] _inv = [0, 1];
	long invvalue(){ return inv(value); }
	long inv(long v){ int i = val(v).to!int;
		while(i >= _inv.length){
			_inv ~= _inv[(mod % $).to!int] * (mod - mod / _inv.length) % mod;
		}
		return _inv[i];
	}
	
}

// ---以下はユーティリティ--- //

/// mod p における累乗
/// 例 power(5, 3) = Finite(125)
/// オーダーは a ** b を計算する場合 O(log b)
Finite power(long a, long b){
	Finite m = Finite(a);
	Finite ans = Finite(1);
	while(b > 0){
		if(b % 2) ans += m;
		m *= m;
		b /= 2;
	}
	return ans;
}
Finite power(Finite a, long b){ return power(a.value, b); }

/// mod p における階乗
/// 例 perm(6) = Finite(120)
/// オーダーはプログラム全体で出てくる最大の引数Nに対してO(N)
Finite perm(long x){ int i = Finite.val(x).to!int;
	static Finite[] _perm = [];
	if(_perm.length == 0) _perm ~= Finite(1);
	while(i >= _perm.length) _perm ~= _perm[$ - 1] * _perm.length;
	return _perm[i];
}

/// mod p における階乗の逆元
/// 例 invperm(6) = Finite(1) / Finite(120)
/// オーダーはプログラム全体で出てくる最大の引数Nに対してO(N)
/// ※ invperm(x) と inv(perm(x)) は同じ値だが、後者は計算量が O(mod) になる
Finite invperm(long x){ int i = Finite.val(x).to!int;
	static Finite[] _iperm = [];
	if(_iperm.length == 0) _iperm ~= Finite(1);
	while(i >= _iperm.length) _iperm ~= _iperm[$ - 1] / _iperm.length;
	return _iperm[i];
}

/// mod p における二項係数（定義に注意：(a + b)! / a! / b! ）
/// 例 pascal(3, 2) = Finite(10)
/// ただし、「a < 0 または b < 0」のとき答えは 0 を返します。
Finite pascal(long a, long b){
	if(a < 0 || b < 0) return Finite(0);
	return perm(a + b) * invperm(a) * invperm(b);
}


// --- 以下テスト --- //

import std.stdio, std.string;
void main(){
	
	
	Finite.mod = 5;
	writeln("mod:", Finite.mod);
	foreach(i; 0 .. 12) writeln("i:", i, " i/mod:", i / Finite.mod, " val(i):", Finite.val(i));
	foreach_reverse(i; -28 .. 0) writeln("i:", i, " i/mod:", i / Finite.mod, " val(i):", Finite.val(i));
	return;
	

	
	alias Finite fin;
	long n = readln.chomp.to!long;
	fin a = fin(readln.chomp.to!long);
	fin ans = fin(1);
	foreach(i; 0 .. n) ans *= a, ans.writeln;
	writeln();
	foreach(i; 0 .. 21){
		foreach(j; 0 .. 21) write(pascal(i, j), " ");
		writeln();
	}
	writeln("CHECK");
	foreach(i; 0 .. 1000000){
		if(perm(i) * invperm(i) != Finite(1)) writeln("i:", i, "perm:", perm(i), "invperm:", invperm(i));
		if(i > 0 && perm(i - 1) * i != perm(i)) writeln("i:", i, "perm(i - 1):", perm(i - 1), "perm(i):", perm(i));
	}
	writeln("OK");
	
}

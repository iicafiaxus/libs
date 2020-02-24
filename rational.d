// 有理数体
// 負の数を与えても大丈夫
// Finiteと仕様を揃えている

// gcdを取るためコンストラクタのオーダーがlogに注意

import std.conv;
struct Rational{
	long upper, lower;
	static long mod; // Finiteとの互換のため。意味はない
	this(long x){
		this(x, 1, 1);
	}
	this(long u, long v){
		assert(v != 0);
		if(v < 0) u = -u, v = -v;
		this(u, v, gcd(u, v));
	}
	this(long u, long v, long d){
		this.upper = u / gcd(u, v), this.lower = v / gcd(u, v);
	}
	real value(){ return upper.to!real / lower.to!real; }
	bool opCast(T: bool)(){ return upper != 0; }
	Rational opUnary(string s){ long u, v;
		if(s == "+") u = upper, v = lower;
		else if(s == "-") u = -upper, v = lower;
		else if(s == "++") u = upper + lower, v = lower;
		else if(s == "--") u = upper - lower, v = lower;
		else assert(0, "Operator unary " ~ s ~ " not implemented");
		return Rational(u, v, 1);
	}
	Rational opBinary(string s)(Rational r){
		return opBinary!s(r.upper, r.lower);
	}
	Rational opBinary(string s)(long x){ 
		return opBinary!s(x, 1);
	}
	Rational opBinary(string s)(long upper2, long lower2){ long u, v;
		if(s == "+") u = upper * lower2 + lower * upper2, v = lower * lower2;
		else if(s == "-") u = upper * lower2 - lower * upper2, v = lower * lower2;
		else if(s == "*") u = upper * upper2, v = lower * lower2;
		else if(s == "/") u = upper * lower2, v = lower * upper2;
		else assert(0, "Operator " ~ s ~ " not implemented");
		return Rational(u, v);
	}
	Rational opBinaryRight(string s)(long x){
		return opBinary!s(x);
	}
	Rational opAssign(long x){ upper = x, lower = 1; return this; }
	Rational opOpAssign(string s)(Rational r){
		return opOpAssign!s(r.upper, r.lower);
	}
	Rational opOpAssign(string s)(long x){
		return opOpAssign!s(x, 1);
	}
	Rational opOpAssign(string s)(long upper2, long lower2){
		Rational y = opBinary!s(upper2, lower2);
		upper = y.upper, lower = y.lower;
		return this;
	}
	bool opEquals(Rational r){
		return upper * r.lower == lower * r.upper;
	}
	int opCmp(Rational r){
		return (upper * r.lower - lower * r.upper).to!int;
	}
	string toString(){ return upper.to!string ~ "/" ~ lower.to!string; }
	Rational inv(){ return Rational(lower, upper); }
	
}

// ---以下はユーティリティ--- //

/// 階乗
/// 例 perm(6) = Rational(120)
/// Finiteとの互換のため実装しているが容易にオーバーフローする。
Rational perm(long x){
	static Rational[] _perm = [];
	if(_perm.length == 0) _perm ~= Rational(1);
	while(x >= _perm.length) _perm ~= _perm[$ - 1] * _perm.length;
	return _perm[x];
}

/// 階乗の逆数
/// 例 invperm(6) = Rational(1, 120)
/// Finiteとの互換のため。容易にオーバフローする。
Rational invperm(long x){ return perm(x).inv; }

/// 二項係数（定義に注意：(a + b)! / a! / b! ）
/// 例 pascal(3, 2) = Rational(10)
/// ただし、「a < 0 または b < 0」のとき答えは 0 を返します。
/// perm とは無関係に、for ループで実装しています。O(min(a, b))
Rational pascal(long a, long b){
	if(a < 0 || b < 0) return Rational(0);
	else{
		Rational ans = Rational(1);
		long n = (a < b)? a: b;
		foreach(i; 0 .. n) ans *= Rational(a + b - i, 1 + i);
		return ans;
	}
}

// 最大公約数（約分用）　　
// 本体はnumber.d
long gcd(long a, long b){
	if(a < 0) a = -a;
	if(b < 0) b = -b;
	return b? gcd(b, a % b): a;
}




import std.stdio;
void main(){
	Rational oldans = Rational(0);
	foreach(i; 0 .. 20){
		Rational ans = 0;
		foreach(k; 0 .. i + 1){
			ans += pascal(i, i - k) * (k + 1) / (i + 1);
		}
		writeln(ans, " ", ans - oldans);
		oldans = ans;
	}
}
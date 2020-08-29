// 整数論
// Finite を要求するものは finite.d にある

/// 最大公約数。最大の公約数。
/// 例 gcd(12, -18) = 6, gcd(-12, -18) = 6, gcd(12, 0) = 12, gcd(0, 0) = 0
/// ※本当は gcd(0, 0) は存在しないが便宜上 0 を返している
long gcd(long a, long b){
	if(a < 0) a = -a;
	if(b == 0) return a;
	if(b < 0) return gcd(a, -b);
	if(a % b == 0) return b;
	if(a < b) return gcd(b, a);
	else return gcd(b, a % b);
}

/// 最小公倍数。0以上で最小の公倍数。
/// 例 lcm(12, -18) = 36, lcm(-12, -18) = 36, lcm(12, 0) = 36, lcm(0, 0) = 0
long lcm(long a, long b){
	if(a < 0) a = -a; if(b < 0) b = -b;
	if(a == 0 && b == 0) return 0;
	return (a / gcd(a, b) * b);
}

/// 約数の集合
/// 1とその数自身も含む、正の約数の集合。
/// 例 divisors(48) = [1, 2, 3, 4, 6, 8, 12, 16, 24, 48]
/// O(√N)
long[] divisors(long a){
	long[] res, res2;
	for(long d = 1; d * d <= a; d ++){
		if(a % d == 0) res ~= d, res2 ~=  a / d;
	}
	foreach_reverse(d; res2) if(res[$ - 1] < d) res ~= d;
	return res;
}

/// a 以下の素数の集合
/// 例 primesTo(48) = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47]
/// 時間O(N f(N))、空間O(N) ただしf(N)は素数の個数(=O(log N))
/// 都度計算なのでコストは都度かかる
long[] primesTo(long a){
	bool[] isNg = new bool[](a + 1);
	isNg[0] = 1, isNg[1] = 1;
	foreach(i; 2 .. a + 1){
		if(isNg[i]) continue;
		foreach(k; 2 .. a / i + 1) isNg[i * k] = 1;
	}
	long[] res;
	foreach(i; 0 .. a + 1) if(! isNg[i]) res ~= i;
	return res;
}

// n 以下の自然数を素因数分解する
// 準備に O(m^2) ただし m は素数の個数（=O(log n) ）
// 1回の実行に O(log a) ただし a は引数
class Factorizer{
    long[] ds; // ds[i]: i を割り切る最小の素数
    this(long n){
        ds = new long[](n + 1);
        foreach(i; 0 .. n + 1) ds[i] = i;
        foreach(i; 2 .. n + 1){
            if(ds[i] < i) continue;
            for(long u = i * 2; u <= n; u += i) if(ds[u] > i) ds[u] = i;
        }
    }

    // 素因数分解（重複度に応じる 例：f(12) = [2, 2, 3]）
    // 小さい順に並べる
    long[] opCall(long a){
        assert(a < ds.length);	    
        long[] res;
        while(a > 1) res ~= ds[a], a /= ds[a];
        return res;
    }

    // 素数の約数の列挙（重複度は無視 例：f(12, 0) = [2, 3]）
    // 小さい順に並べる
    long[] opCall(long a, bool canDuplicate){
        assert(a < ds.length);	    
        if(canDuplicate) return opCall(a);
        long[] res;
        while(a > 1){
            if(res.length == 0 || res[$ - 1] < ds[a]) res ~= ds[a];
            a /= ds[a];
        }
        return res;
    }

}


// n を b 進法で表したときの桁和
long digitSum(long n, long b){
	assert(b >= 2);
	long ans;
	while(n > 0){
		ans += n % b;
		n /= b;
	}
	return ans;
}

// テストコード
import std.stdio;
void main(){
	long x, y;
	x = 12, y = 18, writeln("gcd(", x, ", ", y, ") = ", gcd(x, y));
	x = -12, y = 18, writeln("gcd(", x, ", ", y, ") = ", gcd(x, y));
	x = 12, y = -18, writeln("gcd(", x, ", ", y, ") = ", gcd(x, y));
	x = -12, y = -18, writeln("gcd(", x, ", ", y, ") = ", gcd(x, y));
	x = 12, y = 0, writeln("gcd(", x, ", ", y, ") = ", gcd(x, y));
	x = -12, y = 0, writeln("gcd(", x, ", ", y, ") = ", gcd(x, y));
	x = 0, y = 18, writeln("gcd(", x, ", ", y, ") = ", gcd(x, y));
	x = 0, y = -18, writeln("gcd(", x, ", ", y, ") = ", gcd(x, y));
	x = 0, y = 0, writeln("gcd(", x, ", ", y, ") = ", gcd(x, y));

	x = 12, y = 18, writeln("lcm(", x, ", ", y, ") = ", lcm(x, y));
	x = -12, y = 18, writeln("lcm(", x, ", ", y, ") = ", lcm(x, y));
	x = 12, y = -18, writeln("lcm(", x, ", ", y, ") = ", lcm(x, y));
	x = -12, y = -18, writeln("lcm(", x, ", ", y, ") = ", lcm(x, y));
	x = 12, y = 0, writeln("lcm(", x, ", ", y, ") = ", lcm(x, y));
	x = -12, y = 0, writeln("lcm(", x, ", ", y, ") = ", lcm(x, y));
	x = 0, y = 18, writeln("lcm(", x, ", ", y, ") = ", lcm(x, y));
	x = 0, y = -18, writeln("lcm(", x, ", ", y, ") = ", lcm(x, y));
	// x = 0, y = 0, writeln("lcm(", x, ", ", y, ") = ", lcm(x, y));

	x = 48, writeln("divisors(", x, ") = ", divisors(x));
	x = 48, writeln("primesTo(", x, ") = ", primesTo(x));
	x = 4, writeln("primesTo(", x, ") = ", primesTo(x));
	x = 3, writeln("primesTo(", x, ") = ", primesTo(x));
	x = 2, writeln("primesTo(", x, ") = ", primesTo(x));
	x = 1, writeln("primesTo(", x, ") = ", primesTo(x));


}

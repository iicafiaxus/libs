/*
  多項式ライブラリ(とりあえず)
  多項式の型は作っていないので単にlong[]を使う
  たとえば x²+2x+5 の場合であれば [5, 2, 1]
  係数はmod未満であること
*/

// modの定義も一応入れておくが不要なら使用時に削除すること
const long mod = 1_000_000_007;

/*
  多項式に根を1つ追加
  多項式に(x-a)をかける
  使い方
  p.addZero(a);
*/
void addZero(ref long[] xs, long a){
	int n = xs.length.to!int;
	if(a < 0) a += (-a / mod + 1) * mod;
	a %= mod;
	xs = [0L] ~ xs;
	foreach(i; 0 .. n){
		xs[i] += mod - xs[i + 1] * a % mod, xs[i] %= mod;
	}
}

/*
  多項式から根を1つ削除
  多項式が(x-a)を因子としてもっている前提で、(x-a)でわる
  使い方
  p.removeZero(a);
*/
void removeZero(ref long[] xs, long a){
	int n = xs.length.to!int;
	if(a < 0) a += (-a / mod + 1) * mod;
	a %= mod;
	long tmp = 0;
	foreach_reverse(i; 0 .. n){
		xs[i] += tmp, xs[i] %= mod;
		tmp = xs[i] * a % mod;
	}
	xs = xs[1 .. $];
}

/*
  多項式に多項式をたす
  使い方
  p.add(q);
*/
void add(ref long[] xs, long[] ys){
	int n = xs.length.to!int, m = ys.length.to!int;
	foreach(j; 0 .. m){
		if(xs.length <= j) xs ~= ys[j];
		else xs[j] += ys[j], xs[j] %= mod; 
	}
}

/*
  スカラー倍
  使い方
  p.multiply(k);
*/
void multiply(ref long[] xs, long a){
	int n = xs.length.to!int;
	if(a < 0) a += (-a / mod + 1) * mod;
	a %= mod;
	foreach(i; 0 .. n){
		xs[i] *= a, xs[i] %= mod;
	}
}

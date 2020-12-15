/*
	Zアルゴリズム
	zed(xs)[i]: xs と xs[i .. $] が最初の何文字共通しているか
*/
int[] zed(char[] xs){
	int n = xs.length.to!int;
	int[] res = new int[](n);
	res[0] = n;
	for(int i = 1, j = 1; i < n; ){
		if(j < i) j = i; else if(j >= n) j = n - 1;
		while(j < n && xs[j - i] == xs[j]) j ++;
		res[i] = j - i;
		for(int i0 = i ++; i < n && i + min(n - i, res[i - i0]) < j; i ++){
			res[i] = min(n - i, res[i - i0]);
		}
	}
	return res;
}

// 二分探索

// a 以上 c 以下の範囲で f(x) をみたす最大の x
// ただし、a がみたさない場合は a - 1 を返す ※範囲外エラーに注意
// f は単調減少であること
T uplimit(T)(T a, T c, bool delegate(T) f){
	if(f(c)) return c; if(! f(a)) return a - 1;
	while(a + 1 < c){ T b = (a + c) / 2; if(f(b)) a = b; else c = b; }
	return a;
}

// a 以上 c 以下の範囲で f(x) をみたす最小の x
// ただし、c がみたさない場合は c + 1 を返す ※範囲外エラーに注意
// f は単調増加であること
T downlimit(T)(T a, T c, bool delegate(T) f){
	if(f(a)) return a; if(! f(c)) return c + 1;
	while(a + 1 < c){ T b = (a + c) / 2; if(f(b)) c = b; else a = b; }
	return c;
}


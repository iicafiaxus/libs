/*
  セグメント木
  区間への書き込み、区間からの読み出し
  
  使い方
    
  初期化
    auto seg = new SegTree!(
      long,
        // セットする値の型
      long,
        // 計算結果の型
      delegate (long v1, long v2) => v1 + v2,
        // 値 v1 をセットした場所に値 v2 をセットしたら、結局どんな値をセットしたことになるか
        // 加算する場合なら v1 + v2、上書きする場合なら v2 など
      delegate (long x, int wx, long v) => x + v * wx,
        // 計算結果が x である幅 wx の区間に、値 v をセットしたら、計算結果はどうなるか
        // ※幅とは、たとえば (i, i + 1) なら幅 1 （(i, i + 1) は 1 マスだけからなる区間）
      delegate (long x, int wx, long y, int wy) => x + y,
        // 計算結果が x である幅 wx の区間と、計算結果が y である幅 wy の区間をつなげたら
        // 合わせてできる幅 (wx + wy) の区間の計算結果はどうなるか（x が左、y が右）
      delegate (long v, int wx, int wy) => v,
        // 幅 wx の区間と幅 wy の区間を合わせてできた幅 (wx + wy) の区間に値 v をセットすることは
        // そのうちの左側の幅 wx の区間にとってはどんな値をセットしたことになるか
      delegate (long v, int wx, int wy) => v,
        // 幅 wx の区間と幅 wy の区間を合わせてできた幅 (wx + wy) の区間に値 v をセットすることは
        // そのうちの右側の幅 wy の区間にとってはどんな値をセットしたことになるか
      0
        // 初期値 (=開始直後に1マスだけ読み取ったら何という計算結果になるか)
    )(0, n);
        // 0 以上 n 未満の添字を扱う
    
  値の設定
    seg.setValue(l, r + 1, v);
        // l 以上 (r + 1) 未満の添字からなる区間に値 v をセットする
    
  計算結果の取得
    ans = seg.getValue(l, r + 1);
        // l 以上 (r + 1) 未満の添字からなる区間の計算結果

  コピペ用
    auto seg = new SegTree!(
      long, long, 
      delegate (long v1, long v2) => v1 + v2,
      delegate (long x, int wx, long v) => x + v * wx,
      delegate (long x, int wx, long y, int wy) => x + y,
      delegate (long v, int wx, int wy) => v,
      delegate (long v, int wx, int wy) => v,
      0
    )(0, n);
*/
class SegTree(
	U, T,
	U delegate(U, U) update,
	T delegate(T, int, U) apply,
	T delegate(T, int, T, int) merge,
	U delegate(U, int, int) projectleft,
	U delegate(U, int, int) projectright,
	T initial
){
	int a, b;
	int width;
	bool hasValue;
	SegTree left, right;
	U value;
	T result;
	this(int a, int b){
		this.a = a, this.b = b;
		this.width = b - a;
		if(b - a == 1){
			result = initial;
		}
		else{
			int c = (a + b) / 2;
			left = new SegTree(a, c);
			right = new SegTree(c, b);
			result = merge(left.getResult(), left.width, right.getResult(), right.width);
		}
	}

	// 値の書き込み
	void setValue(U v){ setValue(a, b, v); }
	void setValue(int a, int b, U v){
		if(b <= this.a || this.b <= a) return;
		if(a <= this.a && this.b <= b){
			// 全体への書き込み
			if(hasValue) value = update(value, v);
			else value = v;
			hasValue = 1;
		}
		else{
			// 一部分への書き込み
			divide();
			int wleft = left.getWidth(a, b), wright = right.getWidth(a, b);
			if(wleft > 0 && wright > 0){
				left.setValue(a, left.b, projectleft(v, wleft, wright));
				right.setValue(right.a, b, projectright(v, wleft, wright));
			}
			else if(wleft > 0) left.setValue(a, b, v);
			else if(wright > 0) right.setValue(a, b, v);
			result = merge(left.getResult(), left.width, right.getResult(), right.width);
		}
	}

	// 値を下へおろす (内部用)
	void divide(){
		if(hasValue){
			left.setValue(projectleft(value, left.width, right.width));
			right.setValue(projectright(value, left.width, right.width));
			hasValue = 0;
			result = merge(left.getResult(), left.width, right.getResult(), right.width);
		}
	}

	// 計算結果の取得
	T getResult(){ return getResult(a, b); }
	T getResult(int a, int b){
		if(b <= this.a || this.b <= a) assert(0);
		if(a <= this.a && this.b <= b){
			// 全体からの取得
			if(hasValue) return apply(result, width, value);
			else return result;
		}
		else{
			// 一部分からの取得
			divide();
			int wleft = left.getWidth(a, b), wright = right.getWidth(a, b);
			if(wleft > 0 && wright > 0) return merge(left.getResult(a, b), wleft, right.getResult(a, b), wright);
			else if(wleft > 0) return left.getResult(a, b);
			else if(wright > 0) return right.getResult(a, b);
			assert(0);
		}
	}

	// 幅の取得 (内部用)
	int getWidth(int a, int b){
		if(b <= this.a || this.b <= a) return 0;
		if(a <= this.a && this.b <= b) return width;
		if(a <= this.a) return b - this.a;
		if(this.b <= b) return this.b - a;
		return b - a;
	}

	// ダンプ (デバッグ用)
	string valueString(){
		string v = (hasValue? value.to!string: "-");
		if(left && right){
			v ~= "\t" ~ left.valueString.split("\n").join("\n|\t") ~ "\n\t" ~ right.valueString.split("\n").join("\n\t");
		}
		return v;
	}
	string resultString(){
		string r = ((result == initial)? "-": result.to!string);
		if(left && right){
			r ~= "\t" ~ left.resultString.split("\n").join("\n|\t") ~ "\n\t" ~ right.resultString.split("\n").join("\n\t");
		}
		return r;
	}
	override string toString(){
		return "values:\n" ~ valueString ~ "\nresult:\n" ~ resultString;
	}
}

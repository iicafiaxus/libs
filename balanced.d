/*
平衡二分木（AVL木）
使い方

	// 初期化
	auto bal = new Balanced!long;
		// longでなくてもよいが、a<bが定義されている必要がある

	// 挿入する O(log n)
	bal.insert(a);

	// 挿入し、何番目に入ったかを得る O(log n)
	int r = bal.insertAndGetRank(a);

	// 挿入せずに、もし挿入したら何番目に入るかを得る O(log n)
	int r = bal.getRank(a);

順位は0から始まる
例えば、既存の要素のどれよりも小さい要素を挿入したらそれは0

同順位のものが入るとき、既存の上に入るか下に入るかは不明

*/
class Balanced(T){
	Balanced left, right;
	T value;
	bool hasValue;
	int size;
	int height;
	this(){
	}
	this(T v){
		setValue(v);
	}
	void setValue(T v){
		value = v;
		hasValue = 1;
		size = 1;
		height = 1;
		left = new Balanced, right = new Balanced;
	}
	void insert(T v){
		insertAndGetRank(v);
	}
	int insertAndGetRank(T v){
		int res;
		if( ! hasValue) setValue(v), res = 0;
		else if(size == 1){
			if(v <= value) res = left.insertAndGetRank(v);
			else left.setValue(value), value = v, res = 1;
		}
		else if(size == 2){
			if(v <= left.value) right.setValue(value), value = left.value, left.value = v, res = 0;
			else if(v <= value) right.setValue(value), value = v, res = 1;
			else right.setValue(v), res = 2;
		}
		else{
			if(v <= value) res = left.insertAndGetRank(v), balanceLeft;
			else res = left.size + 1 + right.insertAndGetRank(v), balanceRight;
		}
		size = left.size + right.size + 1;
		height = max(1, left.height + 1, right.height + 1);
		return res;
	}
	void rotateLeft(){
		auto l = left, ll = left.left, lr = left.right, r = right;
		this.left = ll, this.right = l, l.left = lr, l.right = r;
		swap(this.value, l.value);
		l.size += (r.size - ll.size);
		l.height = 1 + max(lr.height, r.height);
		this.height = 1 + max(ll.height, l.height);
	}
	void rotateRight(){
		auto l = left, r = right, rl = right.left, rr = right.right;
		this.left = r, this.right = rr, r.left = l, r.right = rl;
		swap(this.value, r.value);
		r.size += (l.size - rr.size);
		r.height = 1 + max(l.height, rl.height);
		this.height = 1 + max(r.height, rr.height);
	}
	void balanceLeft(){
		if(left.height > right.height + 2){
			if(left.left && left.right && left.left.height < left.right.height){
				left.rotateRight;
			}
			rotateLeft;
		}
	}
	void balanceRight(){
		if(right.height > left.height + 2){
			if(right.left && right.right && right.left.height > right.right.height){
				right.rotateLeft;
			}
			rotateRight;
		}
	}
	void balance(){
		if(right.size > left.size) balanceRight;
		else if(left.size > right.size) balanceLeft;
	}
	int getRank(T x){
		int res;
		if( ! hasValue) res = 0;
		else if(x < value){
			if(left) res = left.getRank(x);
			else res = 0;
		}
		else if(x == value){
			if(left) res = left.size;
			else res = 0;
		}
		else{
			if(left && right) res = left.size + 1 + right.getRank(x);
			else if(left) res = left.size + 1;
			else if(right) res = 1 + right.getRank(x);
			else res = 1;
		}
		return res;
	}
	override string toString(){
		if( ! hasValue) return "[]";
		if(left.hasValue && right.hasValue) return "[" ~ left.toString ~ " " ~ value.to!string ~ " " ~ right.toString ~ "]";
		else if(left.hasValue) return "[" ~ left.toString ~ " " ~ value.to!string ~ "]";
		else if(right.hasValue) return "[" ~ value.to!string ~ " " ~ right.toString ~ "]";
		return "[" ~ value.to!string ~ "]";
	}
}

import std.conv;
struct Vector{
    long x, y;
    Argument arg;
    long square;
    real length;
    this(long x, long y){
        this.x = x, this.y = y;
        if(x != 0 || y != 0) arg = Argument(x, y);
        square = x * x + y * y;
        length = square.to!real.sqrt;
    }
    bool opEquals(Vector v){
        return x == v.x && y == v.y;
    }
	Vector opUnary(string s)(){
		if(s == "+") return Vector(x, y);
		if(s == "-") return Vector(-x, -y);
		assert(0, "Operator unary " ~ s ~ " not implemented");
	}
	Vector opBinary(string s)(Vector v){
		if(s == "+") return Vector(x + v.x, y + v.y);
		if(s == "-") return Vector(x - v.x, y - v.y);
		assert(0, "Operator " ~ s ~ " not implemented");
	}
    Vector opBinary(string s)(long k){
        if(s == "*") return Vector(x * k, y * k);
		assert(0, "Operator " ~ s ~ " not implemented");
    }
    Vector opBinaryRight(string s)(long k){
        if(s == "*") return Vector(k * x, k * y);
		assert(0, "Operator " ~ s ~ " not implemented");
    }

    int quadrant(){ return arg.quadrant; }
    bool isLeftTo(Vector v){ return arg.isLeftTo(v.arg); }
    bool follows(Vector v){ return arg.follows(v.arg); }
}
struct Argument{
    long x, y;
    this(long x, long y){
        assert(x != 0 || y != 0);
        this.x = x, this.y = y;
    }
    
    bool opEquals(Argument a){
        return quadrant == a.quadrant && y * a.x == x * a.y;
    }
	Argument opUnary(string s)(){
		if(s == "+") return Argument(x, y);
		if(s == "-") return Argument(-x, -y);
		assert(0, "Operator unary " ~ s ~ " not implemented");
	}
	Argument opBinary(string s)(Argument a){
		if(s == "+") return Argument(x * a.x - y * a.y, y * a.x + x * a.y);
		if(s == "-") return Argument(x * a.x + y * a.y, y * a.x - x * a.y);
		assert(0, "Operator " ~ s ~ " not implemented");
	}

    // 象限
    // (1, 0) ≦ this ＜ (0, 1) のとき 1　など
    int quadrant(){
        if(x > 0 && y >= 0) return 1;
        if(x <= 0 && y > 0) return 2;
        if(x < 0 && y <= 0) return 3;
        if(x >= 0 && y < 0) return 4;
        assert(0);
    }

    // a から見て this は左側である（aと平行は含まない）
    bool isLeftTo(Argument a){
        return y * a.x - x * a.y > 0;
    }

    // (1, 0) から反時計回りに見て this < a である
    bool follows(Argument a){
        int q = this.quadrant, aq = a.quadrant;
        if(q != aq) return q < aq;
        else return a.isLeftTo(this);
    }
}

// ---------- 以下テスト ---------- //
// https://judge.yosupo.jp/problem/sort_points_by_argument

import std.stdio, std.string, std.array, std.algorithm, std.conv;
void main(){
    int n = readln.chomp.to!int;
    S[] as;
    foreach(_; 0 .. n){
        long[] xy = readln.chomp.split.to!(long[]).array;
        long x = xy[0], y = xy[1];
        if(x == 0 && y == 0) x = 1, y = 0;
        as ~= S(xy[0], xy[1], Argument(-x, y));
    }
    as.sort!"b.arg.follows(a.arg)"();

    foreach(a; as) writeln(a.x, " ", a.y);
}
struct S{
    long x, y;
    Argument arg;
}
import std.stdio, std.conv, std.string, std.array, std.range, std.algorithm, std.container;
import std.math, std.random, std.bigint, std.datetime, std.format;
bool DEBUG = 0; void log(A ...)(lazy A a){ if(DEBUG) print(a); }
void main(string[] args){ if(args.canFind("-debug")) DEBUG = 1;
if(args.canFind("-gen")) gen; else if(args.canFind("-jury")) jury; else solve; }
void print(){ writeln(""); } void print(T)(T t){ writeln(t); }
void print(T, A ...)(T t, A a){ std.stdio.write(t, " "), print(a); }
string unsplit(T)(T xs, string d=" "){ return xs.array.to!(string[]).join(d); }
string scan(){ static string[] ss; while(!ss.length) ss = readln.chomp.split; string res = ss[0]; ss.popFront; return res; }
T scan(T)(){ return scan.to!T; } T[] scan(T)(int n){ return n.iota.map!(i => scan!T()).array; }
T mini(T)(ref T x, T y){ if(x > y) x = y; return x; } T maxi(T)(ref T x, T y){ if(x < y) x = y; return x; }
T mid(T)(T l, T r, bool delegate(T) f){ T m=(l+r)/2; (f(m)?l:r)=m; return f(l)?f(r-1)?r:mid(l,r,f):l; }

// ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- //
void gen(){ // テストケース
}
void jury(){ // 愚直解
}
void solve(){ // 提出解
}

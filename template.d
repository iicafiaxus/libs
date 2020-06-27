import std.stdio, std.conv, std.string, std.array, std.range, std.algorithm, std.container;
import std.math, std.random, std.bigint, std.datetime, std.format;
bool DEBUG = 0; void log(A ...)(lazy A a){ if(DEBUG) print(a); }
void main(string[] args){ args ~= ["", ""]; string cmd = args[1]; if(cmd == "-debug") DEBUG = 1;
if(cmd == "-gen") gen; else if(cmd == "-jury") jury; else solve; } 
void print(){ writeln(""); } void print(T)(T t){ writeln(t); } void print(T, A ...)(T t, A a){ std.stdio.write(t, " "), print(a); }
string unsplit(T)(T xs){ return xs.array.to!(string[]).join(" "); }
string scan(){ static string[] ss; while(!ss.length) ss = readln.chomp.split; string res = ss[0]; ss.popFront; return res; }
T scan(T)(){ return scan.to!T; } T[] scan(T)(int n){ return n.iota.map!(i => scan!T()).array; }
T lowerTo(T)(ref T x, T y){ if(x > y) x = y; return x; } T raiseTo(T)(ref T x, T y){ if(x < y) x = y; return x; }

// ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- //
void gen(){}
void jury(){}
void solve(){

}

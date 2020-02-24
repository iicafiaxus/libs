import std.stdio, std.conv, std.string, std.bigint, std.array;
T read(T)(){ static string[] ss; while(!ss.length) ss = readln.chomp.split; string res = ss[0]; ss.popFront; return res.to!T; }

// これだめ（読み込みバッファがread!longとread!intで別々になってしまう）


void main(){
	long a = read!long;
	int b = read!int;
	string c = read!string;
	
	writeln("a:", a);
	writeln("b:", b);
	writeln("c:", c);
}

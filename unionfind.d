/*
　素集合データ構造
　　・基本的なもの
　　・二部グラフ判定機能つき
*/

// 基本
import std.conv;
class UnionFind{
    int[] rootOf;
    int[][] kidsOf;
    this(int n){
        rootOf = new int[](n);
        kidsOf = new int[][](n);
        foreach(i; 0 .. n) rootOf[i] = i, kidsOf[i] = [i];
    }
    void unite(int a, int b){
        int ra = rootOf[a], rb = rootOf[b];
        if(ra == rb) return;
        if(kidsOf[ra].length < kidsOf[rb].length) unite(b, a);
        else foreach(k; kidsOf[rb]) rootOf[k] = ra, kidsOf[ra] ~= k;
    }
    int find(int a){
        return rootOf[a];
    }
    int getSize(int a){
        return kidsOf[rootOf[a]].length.to!int;
    }
}

// 二部グラフ判定機能つき
import std.conv;
class UnionFind{
    int[] rootOf;
    int[][] kidsOf;
	bool[] isNotBipart;
	int[] color;
    this(int n){
        rootOf = new int[](n);
        kidsOf = new int[][](n);
        foreach(i; 0 .. n) rootOf[i] = i, kidsOf[i] = [i];
		isNotBipart = new bool[](n);
		color = new int[](n);
    }
    void unite(int a, int b){
        int ra = rootOf[a], rb = rootOf[b];
        if(ra == rb){
			if(color[a] == color[b]) isNotBipart[ra] = 1;
		}
        else if(kidsOf[ra].length < kidsOf[rb].length) unite(b, a);
        else{
			bool f = (color[a] == color[b]);
			foreach(k; kidsOf[rb]){
				rootOf[k] = ra, kidsOf[ra] ~= k;
				if(f) color[k] = 1 - color[k];
			}
			isNotBipart[ra] |= isNotBipart[rb];
		}
    }
    int find(int a){
        return rootOf[a];
    }
    int getSize(int a){
        return kidsOf[rootOf[a]].length.to!int;
    }
	bool isBipart(int a){
		return ! isNotBipart[rootOf[a]];
	}
}


// ---------- 以下テスト ---------- //
// https://judge.yosupo.jp/problem/unionfind

import std.stdio, std.string, std.algorithm, std.array, std.conv;
void main(){
    int[] nq = readln.chomp.split.to!(int[]).array;
    int n = nq[0], q = nq[1];
    auto uf = new UnionFind(n);
    foreach(_; 0 .. q){
        int[] tuv = readln.chomp.split.to!(int[]).array;
        int t = tuv[0], u = tuv[1], v = tuv[2];
        if(t == 0) uf.unite(u, v);
        else{
            if(uf.find(u) == uf.find(v)) 1.writeln;
            else 0.writeln;
        }
    }
}

 // downlimit
 // a <= x <= c の範囲で F(x) をみたす最小の x
 // 単調性は前提
 // F(c) がみたされるときは c + 1 が返る
 l Q(l a,l c){b=a+c>>1;return!F(a)?F(c)?a+1<c?F(b)?Q(a,b):Q(b,c):c:c+1:a;}

// 二分探索 (downlimit)
// a <= x <= c の範囲で F(x) をみたす最小の x
// F の単調性は前提
// F(c) がみたされないときは c + 1 が返る
int Q(int a,int c){b=a+c>>1;return!F(a)?F(c)?a+1<c?F(b)?Q(a,b):Q(b,c):c:c+1:a;}

// modintでの逆元
// V[i] は i*V[i]%p=1 をみたす最小の非負整数
long V=[0,1];
foreach(i;2..n)V~=V[p%i]*(p-p/i)%p;

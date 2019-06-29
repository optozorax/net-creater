uses graphcanvas,graphabc;
type
    {������ ���� ���������������,� ������� ���� ����� ����� �����}
    field=array [0..500] of record
                            a:mas;
                            n,m,k:integer;
                            {n - ���������� ������
                             m - �� ����� �� ����� �������������� ���������
                             k - �� ����� ������� m-�� �������������� �� ����� 
                                 ���������}
                          end;
                          
    {������ ��� ��������� ���������,�������������� � ���� �����, ��� ��������� � ��.}
    textfield= array [-50..500] of record
                                    n,m,k:integer;
                                 end;

{���������� ����������}
var
    {������ � ������������ �����(������������ ������ ��� ��������� �����������)}
    T:field;
    
    {������ � �������, �� ������� ������������ ���������� ���������������,
     ����������� �� ����� � ������������� � �������� �������}
    T1:textfield;
    
    {�������� ����� ������ �������, ��� ����, ����� �������� ���������� �� �����}
    {����� ������������ �����������, ��� ����, ����� ������ ���������� �������
     ����}
    {���������� ��������� � ������� �����}
    {��������� �������(��� �������������� � �������� �������) �� ������� � ��������}
    {������ ������� �������� ������, ���������� � ��������}
    {������ ������� ��� �������������� � �������� ������� � ��� ����������}
    {������ ������}
    xmin,xmax,ymin,ymax,n,p,px:integer;
    size:real;
    r_size,o_size,f_size:integer;
    
    {����, ������� ������������ � ������� ����������}
    f:text;

procedure polygonT(n,  m,k,i:integer);
{����� ������������� ��������� ��� ���������� ���������� ���������������!!!}

{��������� ������ ������������� � ����������� ������ ������ n, � ������ �������� �� ���,
 ����� ���������� ���� ������� � ������������ x,y,x1,y1.
 � ��� ��� ������ ������ ���������� ������ � ���������� ���������,�� ������ ������ ����������
 � ������������ � ��������� �������, ���� �������,� ���������� ������ ����� ��� ��,������,
 ������ ���� ������ ���� �������� ������ �����, � x,y ��� � x1,y1 , � �����������
 �� ����� ���� ������ ����� ���� ������������ ��� ���}
 
 {�������� ���������� ������������� � ����������� ������ n, �� ��������� k-��
  �������� m-���� �������������� � ���������� �������}
 var v:integer;
     fi,fi1:real;
     rx,ry,r,xi,yi,r1:real;
     x1,y1,x,y:real;
     flag:boolean;
begin
  {��� ������ ������, ����� ���� ���������� ����� �������}
  flag:=false;  
  if n=-1 then
    begin
        flag:=true;
        n:=3;
    end
  else;
  
  {�������� ���������� k-�� ������� m-�� ��������������}
  if m<>-1 then
    begin
      x:=t[m].a[k].x; y:=t[m].a[k].y;
      x1:=t[m].a[k+1].x; y1:=t[m].a[k+1].y;
    end
  else
   {���� ��� �� ������ �������������� �� ������ ���}
   begin
    x:=0; y:=0; x1:=size; y1:=0;
   end;
  
  {�������� ������ � ������}
  if flag then t[i].n:=4
  else         t[i].n:=n;
  t[i].m:=m;
  t[i].k:=k;
  
  {������ ������������� � ������}
  {������� ���������� ������}
	rx:=(x1+x)/2+((cos(pi/n)/sin(pi/n))*(y1-y))/2;
	ry:=(y1+y)/2-(cos(pi/n)/sin(pi/n)*(x1-x))/2;
	
	{������� ���� ������� ��������������}
	if (y1=y) or (x1=x) then fi:=pi/n
	else                     fi:=-arctan((x1-x)/(y1-y))+pi/n;
    	
  if (y1>y) then fi:=fi+pi;

  if y1=y then
    if x1>x then fi:=fi+pi/2
    else         fi:=fi+3*pi/2
  else;
  
  {������� ������ ��������������}
   r:=sqrt(sqr(x1-x)+sqr(y1-y))/(2*sin(pi/n));

  {������ ��� ������� �� �������}
  if flag then
    begin
        fi:=fi+2*pi/3;
        r1:=r*0.5;
        fi1:=117;
        
        t[i].a[1].x:=rx+r1*cos(fi+fi1/180*pi);
  	    t[i].a[1].y:=ry+r1*sin(fi+fi1/180*pi);

  	    t[i].a[2].x:=rx+r*cos(fi+120/180*pi);
  	    t[i].a[2].y:=ry+r*sin(fi+120/180*pi);

  	    t[i].a[3].x:=rx+r*cos(fi+240/180*pi);
  	    t[i].a[3].y:=ry+r*sin(fi+240/180*pi);

  	    t[i].a[4].x:=rx+r1*cos(fi+(360-fi1)/180*pi);
  	    t[i].a[4].y:=ry+r1*sin(fi+(360-fi1)/180*pi);

  	    t[i].a[5].x:=rx+r1*cos(fi+fi1/180*pi);
  	    t[i].a[5].y:=ry+r1*sin(fi+fi1/180*pi);

  	    t[i].n:=-1;
    end
  else
  	for v:=0 to n do
  	   begin
           {������� ��� ���������� ��������� ����� ������ ��������������, �����
            �� ����� ���� ����� ���������� ������, ������,� ���� �������, �� ���
            ��� �� �� �����,�� ����� �������� ������� �������������, ������� �����
            � ���������}
  	       xi:=rx+r*cos(fi+2*v*pi/n);
  	       yi:=ry+r*sin(fi+2*v*pi/n);

  	       t[i].a[v+1].x:=xi;
  	       t[i].a[v+1].y:=yi;
  	   end;
end;

procedure poly(a:mas; n:integer; cl:color);
{��������� ������ ������������� �������� ������� �, �������� n, �������� ���
 ������ cl}
var
    b:array of Point;
    i:integer;
    cl1:color;
begin
    {��������� ������, ��� ���� ���� ��� ����� �������� ����. ���������}
    setlength(b,n);
    for i:=0 to n-1 do
        begin
            b[i].x:=trunc(a[i+1].x);
            b[i].y:=trunc(a[i+1].y);
        end;
     
    {������ ��������� ��� ��������� ���������}
    cl1:=brushcolor;
    setbrushcolor(cl);
    polygon(b);
    setbrushcolor(cl1);
end;

procedure drawfield;
{��������� ������ ��� �������������� � ���������� �������, �� �����}
var
    i,j:integer;
begin
    {������� ������� ������� ������ �� ������ ��������}
    setpencolor(clwhite);
    rectangle(0,0,xmax+20,ymax+20);
    setpencolor(clblack);

    {���������� ��� ����� �������}
    for i:=1 to n do
        if T[i].n=-1 then
            {��������� ������������� ����� ������, � ���� �� ������ � �������
             ���������������, �� ������� ������� ��������� ���}
            if i=p then
                poly(t[i].a,5,rgb(255,128,128))
            else
                if (p=t[i].m) then
                    poly(t[i].a,5,rgb(128,255,128))
                else   
                    if t[p].m=i then
                        poly(t[i].a,5,rgb(255,255,190))
                    else
                         poly(t[i].a,5,rgb(200,200,200))
        else;        
    //���������� ��� ��������������
    for i:=1 to n do
        if (T[i].n<>0) and (T[i].n<>-1) then
            {��������� ������������� ����� ������, � ���� �� ������ � �������
             ���������������, �� ������� ������� ��������� ���}
            if i=p then
                poly(t[i].a,t[i].n+1,rgb(255,128,128))
            else
                if (p=t[i].m) then
                    poly(t[i].a,t[i].n+1,rgb(128,255,128))
                else   
                    if t[p].m=i then
                        poly(t[i].a,t[i].n+1,rgb(255,255,190))
                    else
                         poly(t[i].a,t[i].n+1,rgb(255,255,255))
        else;       
end;

procedure addT(a,x,x1,x2:integer);
{��������� � ���������� ������ ������������� � ��������� �����������, � �������� �����,
 �� ��������� ��������� ���������}
var
    i:integer;
begin
    {������� �������������}
    n:=n+1;
    {������� ��������}
    for i:=n-1 downto a do
        t1[i+1]:=t1[i];
    {�������� �������� ��������� ���������, ����� ������� ��������� �� ��������}
    for i:=1 to n do 
        if t1[i].m>=a then
            t1[i].m:=t1[i].m+1
        else;
       
    {��������� ��� ������� � �������������� �����}
    t1[a].n:=x; t1[a].m:=x1; t1[a].k:=x2;
end;

procedure deleteT(a:integer);
{������� ������� ��������� �� ������, ��� ������� m, �� ��������� ��������� ���������}
label start;
var
    i:integer;
begin
    {������� ���� ��� ��������}
    start:
    for i:=1 to n do
        if t1[i].m=a then
            begin
                deleteT(i);
                goto start;
            end
        else;
    
    {������� ��� ���������� �������� � �����������}
    for i:=a to n-1 do
      begin
        t1[i].n:=t1[i+1].n;
        if t1[i+1].m>a then
            t1[i].m:=t1[i+1].m-1
        else
            t1[i].m:=t1[i+1].m;
        t1[i].k:=t1[i+1].k;
      end;
    n:=n-1;
end;

procedure sspap; {snub snub pentagonal antiprism}
{� ���� ��������� ��������� �������� ������������� � ����������}
var
    i:integer;
begin
    {������� ������� ������}
    for i:=1 to 500 do
        t[i].n:=0;    
    
    {����� ��������� ����������}
    for i:=1 to n do
        with t1[i] do polygonT(n,m,k,i);
end;

procedure preparing_image;
{��������� ������� ���������� ��� ���� ����� ������ ���������� ������ � 20 ��������
 �� ����� ������, � ��� �� ������� ������ ������ ���������}
var
    i,j:integer;
begin
    {������� ����� ������� ����� ������}
    xmin:=0; ymin:=0;
    xmax:=trunc(size); ymax:=0;
    for i:=1 to n do
        {����� ������, ��� n-����������}
        if (T[i].n<>0) and (T[i].n<>-1) then
            {���������� ��� ����������}
            for j:=1 to T[i].n do
                with t[i].a[j] do
                    begin
                        if x<xmin then xmin:=trunc(x);
                        if y<ymin then ymin:=trunc(y);
                        if x>xmax then xmax:=trunc(x);
                        if y>ymax then ymax:=trunc(y);
                    end
        else
          {������ ������ �� ����� �������}
          if T[i].n=-1 then
              {���������� ��� ����������}
              for j:=1 to 4 do
                  with t[i].a[j] do
                      begin
                          if x<xmin then xmin:=trunc(x);
                          if y<ymin then ymin:=trunc(y);
                          if x>xmax then xmax:=trunc(x);
                          if y>ymax then ymax:=trunc(y);
                      end
          else;
    {������� ��}
    xmax:=xmax-xmin+20;
    ymax:=ymax-ymin+20;
    
    {������� ��� ����� ���, ����� �� ���� ����� �� �������� �� ������� ������, 
     ���� ��� �� ����� ������� �����}
    for i:=1 to n do
        if T[i].n<>-1 then
           {����� ������, ��� n-����������}
           for j:=1 to T[i].n+1 do
               begin
                    T[i].a[j].x:=T[i].a[j].x-xmin+20;
                    T[i].a[j].y:=T[i].a[j].y-ymin+20;
               end
        else
            {������ ������ �� ����� �������}
            for j:=1 to 5 do
                begin
                     T[i].a[j].x:=T[i].a[j].x-xmin+20;
                     T[i].a[j].y:=T[i].a[j].y-ymin+20;
                end;
                
    {�������� ������� ���� �������� ����� ������� ����� ����� ��������}
    sizex:=xmax+20;
    sizey:=ymax+20;
end;

procedure textcenter(s:string);
{������� ������ s ���������� ������}
var
    x,y:integer;
begin
    x:=windowwidth div 2;
    y:=windowheight div 2;
    
    x:=x-textwidth(s) div 2;
    y:=y-textheight(s) div 2;
    
    textout(x,y,s);
end;

var
    s:string;
    flag:boolean;

procedure vacuum(key:integer);
{���������-��������, �����, ����� ������ �� ����������� �� �������}
begin
end;

procedure addsymbol(key:integer);
{��������� ��������� �� ������� � ������ s, ��� ���������� ������� onkeydown}
begin
    {���������� ����� � �����}
    if ((key>64) and (key<91)) or (key=32) or ((key>47) and (key<58)) then
        s:=s+lowcase(chr(key))
    else
        {������ �������}
        if (key=8) then
            delete(s,length(s),1)
        else
            {������ ������ ������}
            if key=13 then
                begin
                    flag:=true;
                    onkeydown:=vacuum;
                end
            else;
            
     {������� �������� ������ � �������� �������}
     clearwindow;
     textcenter('Please enter a filename for creating:'+chr(10)+' ');
     redraw;
end;

procedure write_mas;
{��������� ������� �������� ������ � �������� ����}
var
    i:integer;
begin
    {������������ ����}
    rewrite(f);
    {������� ���}
    for i:=1 to n-1 do
        writeln(f,t1[i].n,' ',t1[i].m,' ',t1[i].k);
    i:=i+1;
    write(f,t1[n].n,' ',t1[n].m,' ',t1[n].k);
    {������� ����}
    close(f);
end;
    
procedure loadfile(loaded_file:string);
{������� ���� � ��������� s}
begin
    {��������� ��������� �������}
    setwindowsize(500,200); clearwindow;
    setwindowtitle('NetCreater v1.07');
    setfontsize(16); setfontname('Courier New');
    
    {��������� ��������� ������ �� �����}
    s:=loaded_file;
    {���� ���� ������� ����������}
    if FileExists(loaded_file) then
      begin
        assign(f,loaded_file);
        reset(f);

        n:=0;
        repeat
            n:=n+1;
            readln(f,t1[n].n,t1[n].m,t1[n].k);
        until eof(f);

        close(f);
      end
    else
      {���� ���, �� ���������� ������������ �� ���� � ��������� ���������}
      begin
        clearwindow;
        textcenter('File is not exists.');
        redraw;
        sleep(10000);
        halt;
      end;
end;    
    
procedure enterfile;
{��������� ��� ����� ����� �����}
begin
    {������ ��������� ��������}
    s:='';
    setwindowsize(500,200); clearwindow;
    setwindowtitle('NetCreater v1.07');
    setfontsize(16); setfontname('Courier New');
    
    {��������� ��������}
    flag:=false;
    textcenter('Please enter a filename for creating:'+chr(10)+' ');
    onkeydown:=addsymbol;
  
    {������ 0.5� ��������� ���������� �� ������ � ������}
    repeat
        sleep(500);
        clearwindow;
        textcenter('Please enter a filename for creating:'+chr(10)+s+'_');
        redraw;
        
        sleep(500);
        clearwindow;
        textcenter('Please enter a filename for creating:'+chr(10)+s+' ');
        redraw;
    {�� ����,���� �� ��������� �������� �����(������������ ������ �����)}    
    until flag;
    
    {��������� ����������}
    s:=s+'.Net';
    
    delete(s,1,1);
    {������� ���� � ����� ������}
    assign(f,s);

    {��������� ������ ���������� �������}
    n:=1;
    t1[1].n:=3;
    t1[1].m:=-1;
    t1[1].k:=0;

    {������� ��� ��������� ������ � ������}
    write_mas;
end;

procedure right_interface;
{��������� ������� ������� ��������� � ������ �������� � �������� ��������� � ���}
var
    i,k,x,y,j:integer;
    s:string;
begin
    {�������������� ������}
    setpencolor(clwhite);
    rectangle(xmax+20,0,windowwidth,windowheight);
    setpencolor(clblack);
   
    {���� ��������� �������� ����������}
    k:=p-(ymax+20) div (textheight(' ')+7) div 2;
    {���������� �� ���� �� ���������, ������ ��� �������, �� ����� ����� ���������
     (���������� ���� ����� ������������� ������������ �������� ����)}
    for i:=k to min(n,p+(ymax+20) div (textheight(' ')+7) div 2+3) do
    {���� ������ ������� �� �� ������� ���}
    if t1[i].n<>0 then
        begin
            {���������� ��������� ������}
            x:=xmax+20+2+textheight(' ');
            y:=windowheight div 2-textheight(' ')+(i-p)*(textheight(' ')+7);
            
            {������� ������ � �������,������� ���� �������}
            with t1[i] do s:=tostr1(n)+tostr1(k); {tostr1(m)+}
            
            {������� ����������}
            {���� �� ������� ������� ���������,�� ������� ��� �������}
            if i=p then
               setbrushcolor(rgb(255,128,128))
            else
                if t[i].n=-1 then
                   setbrushcolor(rgb(200,200,200))
                else
                    setbrushcolor(clwhite);
            rectangle(x-1,y-3,x+6+textwidth(s),y+3+textheight(s));  setpencolor(clblack);
            if i=p then
                rectangle(x+1+textwidth('   ')*(px-1),y-1,x+3+textwidth('   ')*px,y+1+textheight('   '))
            else;
            
            setbrushstyle(bsclear);
            {������� �����}
            textout(x,y,s);
            textout(x+6+textwidth(s),y,tostr1(i));
            setbrushstyle(bssolid);
        end
    else;
    setbrushcolor(clwhite);
end;

procedure polygon_nums;
{������� ����� � ����� �����, ������������ ����� ������ � �������}
var
    i,j,x1,y1:integer;
begin
    {������ ��� ������ ����������}
    setbrushstyle(bsclear);
    for i:=1 to n do
        {�� ������� ������ ���� �������}
        if t[i].n<>-1 then
          begin
            {������� ���������� ����� ������}
            x1:=0;y1:=0;
            for j:=1 to t[i].n do
                begin
                    x1:=x1+trunc(t[i].a[j].x);
                    y1:=y1+trunc(t[i].a[j].y);
                end;

            {�������� ���������� ���������� ������}
            x1:=x1 div t1[i].n;
            y1:=y1 div t1[i].n;
            x1:=x1-textwidth(tostr(i)) div 2;
            y1:=y1-textheight(tostr(i)) div 2;

            {������� �����}
            textout(x1,y1,tostr(i));
          end
        else;
    setbrushstyle(bssolid);
end;

procedure render_image;
{��������� ������ ����������� ������ ����������� � ������, � ��������� ��� ���
 ��������}
var i,j:integer;
begin
    preparecanvas;
    clearcanvas;
    size:=r_size;
    
    {������� ���������� ������ ������� ��������������}
    sspap;
    
    {���������� �������� � ������ ������������ �������}
    preparing_image;
    
    sizex:=xmax+20; sizey:=ymax+20;
    
    {���������� ��� ��������������}
    for i:=1 to n do
        {������ ������ ��� ����� �������}
        if T[i].n=-1 then
            begin 
                outpoly(t[i].a,5,argb(255,200,200,200));
                for j:=1 to 4 do
                    with t[i] do
                    lineout(a[j].x,a[j].y,a[j+1].x,a[j+1].y);                
            end
        else;        
    for i:=1 to n do
        {����� ������ ��� n-����������}
        if (T[i].n<>0) and (T[i].n<>-1) then
            begin
                outpoly(t[i].a,t[i].n+1,argb(255,255,255,255));
                for j:=1 to T[i].n do
                    with t[i] do
                    lineout(trunc(a[j].x),a[j].y,a[j+1].x,a[j+1].y);
            end
        else;

    {��������� ����}
    savecanvas(s);
    
    {���������� ����� ������}
    size:=o_size;
    
    {������� ���������� ��� �������� ��������� � ����, �� ����������� ������}
    sspap;
    preparing_image;    
end;

procedure editText(key:integer);
label start2;
var i:integer;
{��������� �������������� ������ � �������� �������,��� ������ ������� ������}
begin
    {��������� ����� ������ � ���� ���������, ������� �������� ������������, ���
     ����������}
    setwindowtitle('Loading...');
    
    {������������ ������ ������� ����� ������������, ��������� ��������, ����������,
     �������� � ���������� ��������}
    case key of
        {������������ �� ����������}
        vk_up: if p<>1 then p:=p-1;
        vk_down: if p<>n then p:=p+1;
        vk_right: if px<>2 then px:=px+1 else;
        vk_left: if px<>1 then px:=px-1 else;
        vk_end: p:=n;
        vk_home: p:=1;
        
        vk_back: begin 
                 if p<>1 then begin deleteT(p); p:=p-1; end else;
                 if p>n then p:=n;
                 {������� ���������� ������ ������� ��������������}
                 sspap;
    
                 {���������� �������� � ������ ������������ �������}
                 preparing_image;
                 end;
        
        187,107:begin
                    case px of
                        1: if t1[p].n=-1 then t1[p].n:=3 else if t1[p].n<>32 then t1[p].n:=t1[p].n+1;
                        2: if (t1[p].k<>t1[t1[p].m].n) and (t1[p].k<>0) then t1[p].k:=t1[p].k+1;
                    end;
                    {��������� ����������,����� � ���������}
                    sspap;
                    preparing_image;
                end;
        189,109:begin
                    case px of
                        1: if t1[p].n=3 then t1[p].n:=-1 else if t1[p].n<>-1 then t1[p].n:=t1[p].n-1 else;
                        2: if (t1[p].k<>1) and (t1[p].k<>0) then t1[p].k:=t1[p].k-1;
                    end;
                    {���� �� �������� ������� ��������, � �� �� ������������ �������
                     �������� ��� ����������� ������, ���� ����� ����, �� ������� ��
                     � �� ��������, � �������� �� �������, ������ ��� �������� �����
                     ���� ����� � ��� ������}
                    start2:
                    for i:=2 to n do
                        if t1[t1[i].m].n<t1[i].k then
                           begin
                             deleteT(i);
                             goto start2;
                           end
                        else;

                    {��������� ����������,����� � ���������}
                    sspap;
                    preparing_image;
                end;

        {��������� �������, �� ������� +1 �� �������, � �������� �� �� ��������������,
         �� ������� �� ������ ��� ������, ������ ������ ������� �� ����� �������}
        vk_a:  if t1[p].n<>-1 then
                   begin
                    addT(p+1,3,p,1);
                    p:=p+1;

                    {��������� ����������,����� � ���������}
                    sspap;
                    preparing_image;
                   end
               else;
               
        {��������� ����� � ����������� ����}
        vk_s: write_mas;
       
        {�������� ��������� � ����� ������� �������}
        vk_r: begin sizeX:=xmax*r_size div o_size+20; sizey:=ymax*r_size div o_size+20; render_image; end;
        
        {����������� ������� ������� ��������, �� ���� ��������, ��� ����� -
         ����� �������}
        vk_p: if o_size<200 then begin o_size:=o_size+5; size:=o_size; sspap; preparing_image; end;
        vk_i: if o_size<>25 then begin o_size:=o_size-5; size:=o_size; sspap; preparing_image; end;
        
        {����������� ������� �������� ��� ����������,�� ���� ��������, ��� �����
         - ����� �������}
        vk_t: if r_size<400 then r_size:=r_size+5;
        vk_e: if r_size<>25 then r_size:=r_size-5;
        
        {����������� ������� ������}
        vk_g: begin f_size:=f_size+1; setfontsize(f_size); sspap; preparing_image; end;
        vk_d: if f_size<>5 then begin f_size:=f_size-1; setfontsize(f_size); sspap; preparing_image; end;
    end;
    
    {����������� ���� � ������������ � ������������ ��������}
    setwindowsize(xmax+20+textwidth('            ')+textheight(' '),ymax+20);
    
    {������ ���������}
    drawfield;
    
    {������ ������� ���������}
    right_interface;
    
    {������� ������ ����� �� ����� �������}
    polygon_nums;
    
    redraw;
    {���������� ������� ���������, ����� ������������ ����, ��� ������ �������� 
     ��������}
    setwindowtitle('NetCreater v1.07  o_size:' + tostr(o_size)+'  r_size:'+tostr(r_size)+'  f_size:'+tostr(f_size));
end;

begin
    {�������������� ������ ��� �������� ����������}
    pensizeset(1.3); f_size:=8; o_size:=60; r_size:=300; size:=o_size;
    
    {��������� ��������� �������}
    lockdrawing; setfontname('Courier New'); setsmoothingoff; SetWindowIsFixedSize(true);
    
    {���� ����� �����}
    if paramcount=0 then enterfile
    else                 loadfile(paramstr(1));
    
    {��������� ��������}
    clearwindow;setfontsize(f_size); p:=1; px:=1;
    t1[1].n:=t1[1].n-1;
    edittext(187);
    
    {�� ������� ������� ������ ������������ ��������}
    onkeydown:=edittext;
end.
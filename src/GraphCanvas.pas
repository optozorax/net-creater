unit GraphCanvas;
type
    //Тип цвета с альфа-каналом
    pixel=record a,r,g,b:byte; end;
    
    //Канвас с альфа-каналом
    canvas= array [,] of pixel;
    
    //Тип точки
    point= record x,y:real; end;
    
    //Тип массива для рисования полигона
    mas= array [1..33] of point;

var
   //На всю программу один канвас
   win:canvas;
   
   //Цвет и толщина кисти и пера
   pencolor:pixel;
   brushcolor:pixel;
   brushfill:boolean;

   pensize:real;
   
   {Степень сглаживания SMoothNumber - SMN, макс. 16,мин. 1}
   smn:byte;
   
   sizeX,sizeY:integer;


(*ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИИ*)
  function max(a,b:real):integer;
  {Находит максимум среди двух данных чисел}
  begin
       if a>b then max:=trunc(a)
       else        max:=trunc(b);
  end;

  function min(a,b:real):integer;
  {Находит минимум среди двух данных чисел}
  begin
       if a<b then min:=trunc(a)
       else        min:=trunc(b);
  end;
  
  function tostr(n:integer):string;
  var s:string;
  begin
       str(n,s);
       tostr:=s;
  end;
  
  function tostr1(n:integer):string;
  var s:string;
  begin
       str(n:3,s);
       tostr1:=s;
  end;
  
  function polygon(cx,cy,r,f:real; n:integer):mas;
  {Процедура возращает массив с координатами правильного многоугольника с количествои
   сторон - n, заданным радиусом, заданным углом поворота, с заданными координатами
   центра}
  var i:integer;
      a:mas;
  begin
       for i:=1 to n+1 do
           begin
                a[i].x:=cx+r*cos(f+2*pi*i/n);
                a[i].y:=cy+r*sin(f+2*pi*i/n);
           end;
       polygon:=a;
  end;
(*ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИИ*)


(*ФУНКЦИИ ДЛЯ РАБОТЫ С ПЕРОМ И КИСТЬЮ*)
  procedure pensizeset(a:real);
  begin
       pensize:=a;
  end;

  procedure pencolorset(a:pixel);
  begin
       pencolor:=a;
  end;

  procedure brushcolorset(a:pixel);
  begin
       brushcolor:=a;
  end;

  procedure brushfillset(a:boolean);
  begin
       brushfill:=a;
  end;
  
  procedure smoothset(a:byte);
  begin
       smn:=a;
  end;
(*ФУНКЦИИ ДЛЯ РАБОТЫ С ПЕРОМ И КИСТЬЮ*)


(*ФУНКЦИИ ДЛЯ РАБОТЫ С ЦВЕТОМ*)
  function addpixel(a,b:pixel):pixel;
  {Накладывает пиксель А поверх пикселя В с учетом прозрачности обоих,и возвращает
   итоговый цвет}
   
    function add(r,r1,a,a1:byte):byte;
    {Функция складывает один цвет с учетом прозрачности}
    var i:integer;
    begin
         i:=(r1*(a1-a)+r*a) div a1;
         if i>255 then i:=255;
         if i<0 then i:=0;
         add:=i;
    end;
   
  var c:pixel;
  begin
       c.a:=max(a.a,b.a);
       //c.a:=add(a.a,b.a,a.a,b.a);
       c.r:=add(a.r,b.r,a.a,b.a);
       c.g:=add(a.g,b.g,a.a,b.a);
       c.b:=add(a.b,b.b,a.a,b.a);

       addpixel:=c;
  end;

  function argb(a,r,g,b:integer):pixel;
  {Преобразует числа в типизированные данные,в частности цвет с альфа-каналом в
   тип,используемый в программе}
  var cl:pixel;
  begin
       if a>255 then a:=255; if a<0 then a:=0;
       if r>255 then r:=255; if r<0 then r:=0;
       if g>255 then g:=255; if g<0 then g:=0;
       if b>255 then b:=255; if b<0 then b:=0;
       cl.a:=a; cl.r:=r; cl.g:=g; cl.b:=b;
       argb:=cl;
  end;
(*ФУНКЦИИ ДЛЯ РАБОТЫ С ЦВЕТОМ*)


(*ФУНКЦИИ ДЛЯ РАБОТЫ СО ВСЕЙ ОБЛАСТЬЮ КАНВАСА*)
  procedure savecanvas(s:string);
  {Процедура сохраняет канвас в формате .bit}
  var
     t:file of byte;
     i,j:integer;
     cl:pixel;
  begin
       assign(t,s+'.bit');
       rewrite(t);
       write(t,sizeX mod 256, sizeX div 256,0,0);
       write(t,sizeY mod 256, sizeY div 256,0,0);
       for j:=1 to sizey do
           for i:=1 to sizex do
               begin
                    cl:=addpixel(win[i,j],argb(255,255,255,255));
                    write(t,cl.b,cl.g,cl.r);
               end;
       close(t);
  end;
  
  procedure readcanvas(s:string);
  {Процедура считывает канвас в формате .bit}
  var
     t:file of byte;
     i,j,x,y:integer;
     cl:pixel;
     c,c1,c2,c3:byte;
  begin
       assign(t,'D:/BMP/'+s+'.bit');
       reset(t);
       read(t,c,c1,c2,c3);
       x:=c1*256+c;
       read(t,c,c1,c2,c3);
       y:=c1*256+c;
       for j:=1 to y do
           for i:=1 to x do
               begin
                    read(t,c,c1,c2);
                    cl:=argb(255,c2,c1,c);
                    if (j<=sizey) and (i<=sizex) then win[i,j]:=cl;
               end;
       close(t);
  end;
  

  procedure clearcanvas;
  {Процедура очищает канвас прозрачным цветом}
  var i,j:integer;
  begin
       try     
       for i:=0 to sizeX do
           for j:=0 to sizeY do
               win[i,j]:=argb(255,255,255,255);
       except
       writeln;
       end;
  end;

  procedure preparecanvas;
  {Процедура подгатавливает графические режимы и сам канвас для работы}
  begin
       setlength(win,sizeX+2,sizeY+2);
       pencolorset(argb(255,0,0,0));
       pensizeset(1);
       brushcolorset(argb(0,255,255,255));
       brushfillset(false);
       smoothset(4);
       //sizex:=640; sizey:=480;

       clearcanvas;
  end;
(*ФУНКЦИИ ДЛЯ РАБОТЫ СО ВСЕЙ ОБЛАСТЬЮ КАНВАСА*)


(*ФУНКЦИИ ДЛЯ РИСОВАНИЯ В КАНВАС*)
  procedure pixelset(x,y:integer; cl:pixel);
  {Процедура рисует в канвас целый пиксель с учетом наложения цвета}
  begin
       if (x>=0) and (y>=0) and (x<=sizeX) and (y<=sizeY) then
         if (cl.a<>255) and (win[x,y].a<>0) then win[x,y]:=addpixel(cl,win[x,y])
         else                                    win[x,y]:=cl
       else;
  end;
  {procedure pixelout(x,y:integer);
  begin outpixel(x,y,pencolor); end;}
  
  procedure outcircle(x,y,r,t:real; cl:pixel);
  {Процедура рисует в канвас окружность указанной толщины, указанного цвета,
   с указанным центром и радиусом. Если ещё и указан цвет заливки, то рисует
   внутри окружности и заливку}
  var
     k,kb:integer;
     i,j,i1,j1:integer;
     x1,y1:real;

     cl1,cl2:pixel;
     
     a,b,r1,t1,rt:real;
  begin
       //Готовим переменные для оптимизации
       r1:=r; t1:=t;
       rt:=sqr(r-t/2+0.7); r:=sqr(r); t:=sqr(t/2);
       
       
       //Цикл, где перебираются все точки и где рисуется окружность
       for i:=max(x-r1-t1-2,0) to min(x+r1+t1+2,sizeX) do
           for j:=max(y-r1-t1-2,0) to min(y+r1+t1+2,sizeY) do
               begin

                  {*СГЛАЖИВАНИЕ*}
                  k:=0; kb:=0;
                  for i1:=1 to smn do
                      for j1:=1 to smn do
                          begin
                               x1:=i+i1*1/(smn+1);
                               y1:=j+j1*1/(smn+1);
                               a:=sqr(x-x1); b:=sqr(y-y1);
                               if a+b<=rt then kb:=kb+1 else;
                               if sqr(a+b+r-t)<=4*r*(a+b) then k:=k+1 else;
                          end;
                  {*СГЛАЖИВАНИЕ*}

                  {*ПОЛУЧЕНИЕ ЦВЕТА И ВЫРИСОВКА ПИКСЕЛЯ*}
                  if (k<>0) or (kb<>0) then
                     begin
                          //Здесь получается цвет, соответствующий части цвета
                          //фона и части цвета обода
                          cl1:=argb(cl.a*k div sqr(smn),cl.r,cl.g,cl.b);
                          cl2:=argb(brushcolor.a*kb div sqr(smn),brushcolor.r,brushcolor.g,brushcolor.b);
                          if k=0 then cl1:=cl2
                          else
                              if kb=0 then cl1:=cl1
                              else if brushfill then cl1:=addpixel(cl1,cl2) else;
                          pixelset(i,j,cl1);
                     end;
                  {*ПОЛУЧЕНИЕ ЦВЕТА И ВЫРИСОВКА ПИКСЕЛЯ*}
             end;
  end;
  
  procedure circleout(x,y,r:real);
  {Процедура рисует окружность с указанноым центром и радиусом,со стандартными
   цветом и толщиной}
  begin
       outcircle(x,y,r,pensize,pencolor);
  end;
  


  procedure outline(x1,y1,x2,y2,t:real; cl:pixel);
  {Процедура рисует сглаженную прямую от первой точки до второй, с указанным цветом,
   с указанной толщиной}
  var dx,dy,r:real;
  
      function in_line(x,y:real):byte;
      {Функция определяет, находится ли точка внутри прямоугольникка с координатами
       бока x1,y1,x2,y2 и высотой t}
      var
         rx,ry:real;
      begin
           x:=x-(x1+x2+1)/2; y:=y-(y1+y2+1)/2;

           ry:=abs(dy*x-dx*y);
           rx:=abs(dx*x+dy*y);
           if (ry<=r*t) and (rx<=((sqr(dx)+sqr(dy))/2)) and (r<>0) then in_line:=1
           else in_line:=0;
      end;
      
  var
     cl1:pixel;
     i,j,i1,j1,k:integer;
     x,y:real;
  begin
     //Начальные присвоения для оптимизации
     cl1:=cl;
     dx:=x2-x1; dy:=y2-y1;
     r:=sqrt(sqr(dx)+sqr(dy));
     t:=t/2;
     
     
     //Цикл, где перебираются все точки и рисуется прямая
     for i:=max(min(x1,x2)-2,0) to min(max(x1,x2)+2,sizeX) do
         for j:=max(min(y1,y2)-2,0) to min(max(y1,y2)+2,sizeY) do
             begin
                  {*СГЛАЖИВАНИЕ*}
                  k:=0;
                  for i1:=1 to smn do
                      for j1:=1 to smn do
                          begin
                               x:=i+i1*1/(smn+1);
                               y:=j+j1*1/(smn+1);
                               k:=k+in_line(x,y);
                          end;
                  {*СГЛАЖИВАНИЕ*}
                  
                  //Здесь делается соответствующий цвет
                  cl1.a:=cl.a*k div (sqr(smn));
                  pixelset(i,j,cl1);
             end;
  end;
  
  procedure lineout(x,y,x1,y1:real);
  {Процедура рисует отрезок,проходящий через две точки,со стандартной толщиной
   и цветом}
  begin
       outline(x,y,x1,y1,pensize,pencolor);
  end;

  procedure outpoly(a:mas; n:integer; cl:pixel);
  {Процедура рисует закрашенный многоугольник, координаты которого заданы в массиве
   а, с количеством сторон n и заданным цветом заливки.}
  var s,s1:real;
    function triangleS(x1,y1,x2,y2,x3,y3:real):real;
    {Процедура определяет площадь треугольника с заданными координатами}
    begin
         triangleS:=abs(((x1-x3)*(y2-y3)-(x2-x3)*(y1-y3))/2);
    end;

    function polyS(x,y:real; a:mas; n:integer):real;
    {Процедура определяет сумму площадей из всех треугольников, которые составлены
     из сторон из массива А,и заданной точки}
    var s:real;
        i:integer;
    begin
         s:=0;
         for i:=1 to n-1 do s:=s+triangleS(x,y,a[i].x,a[i].y,a[i+1].x,a[i+1].y);
         polyS:=s;
    end;
    
  var i,j,i1,j1,k:integer;
      minx,maxx,miny,maxy:integer;

      x,y:real;
      cl1:pixel;
  begin
       //Определяем центр многоугольника
       s:=0;
       for i:=1 to n-1 do
         s:=s+(a[i+1].x-a[i].x)*(a[i+1].y+a[i].y);
        s:=abs(s)/2;

       //Определяем границы рисования
       cl1:=cl;
       minx:=trunc(a[1].x);
       for i:=1 to n do minx:=min(a[i].x,minx);
       minx:=max(minx-2,0);

       miny:=trunc(a[1].y);
       for i:=1 to n do miny:=min(a[i].y,miny);
       miny:=max(miny-2,0);

       maxx:=trunc(a[1].x);
       for i:=1 to n do maxx:=max(a[i].x,maxx);
       maxx:=min(maxx+2,sizeX);

       maxy:=trunc(a[1].y);
       for i:=1 to n do maxy:=max(a[i].y,maxy);
       maxy:=min(maxy+2,sizey);

       //Сам цикл перебора всех пикселей
       for i:=minx to maxx do
           for j:=miny to maxy do
               begin
                    {*СГЛАЖИВАНИЕ*}
                    k:=0;
                    for i1:=1 to smn do
                        for j1:=1 to smn do
                            begin
                                 x:=i+i1*1/(smn+1);
                                 y:=j+j1*1/(smn+1);
                                 
                                 //Сам код лпределения нахождения точки
                                 //Внутри многоугольника А
                                 s1:=polyS(x,y,a,n);
                                 if abs(s-s1)<0.001 then
                                    k:=k+1;
                            end;
                    cl1.a:=cl.a*k div (sqr(smn));
                    {*СГЛАЖИВАНИЕ*}
                    
                    //Рисуем пиксель с учетом сглаживания
                    pixelset(i,j,cl1);
               end;
  end;
  
  procedure polyout(a:mas; n:integer);
  begin
       outpoly(a,n,brushcolor);
  end;
(*ФУНКЦИИ ДЛЯ РИСОВАНИЯ В КАНВАС*)


end.

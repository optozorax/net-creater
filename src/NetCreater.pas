uses graphcanvas,graphabc;
type
    {Массив всех многоугольников,у которых есть связь между собой}
    field=array [0..500] of record
                            a:mas;
                            n,m,k:integer;
                            {n - количество сторон
                             m - на каком по счету многоугольнике образован
                             k - на какой стороне m-го многоугольника по счету 
                                 образован}
                          end;
                          
    {Массив для генерации развертки,представляется в виде чисел, без координат и пр.}
    textfield= array [-50..500] of record
                                    n,m,k:integer;
                                 end;

{Глобальные переменные}
var
    {Массив с координатами точек(используется только при отрисовке изображения)}
    T:field;
    
    {Массив с числами, по которым генерируются координаты многоугольников,
     считывается из файла и релактируется в реальном времени}
    T1:textfield;
    
    {Смещение самой первой стороны, для того, чтобы картинка уместилась на экран}
    {Точки максимальной удаленности, для того, чтобы задать корректные размеры
     окна}
    {Количество элементов в массиве чисел}
    {Положение курсора(для редактирования в реальном времени) по строкам и столбцам}
    {Размер стороны рисуемой фигуры, измеряется в пикселях}
    {Размер стороны при редактировании в реальном времени и при рендеринге}
    {Размер шрифта}
    xmin,xmax,ymin,ymax,n,p,px:integer;
    size:real;
    r_size,o_size,f_size:integer;
    
    {Файл, который ассоциирован с текущей разверткой}
    f:text;

procedure polygonT(n,  m,k,i:integer);
{Очень универсальная процедура для построения правильных многоугольников!!!}

{Процедура строит многоугольник с количеством сторон равным n, и причем строится он так,
 чтобы основанием была сторона с координатами x,y,x1,y1.
 И так как дается только количество сторон и координаты основания,то размер фигуры выбирается
 в соответствии с исходными данными, угол наклона,и координаты центра точно так же,причем,
 важную роль играет куда положить первую точку, в x,y или в x1,y1 , в зависимости
 от этого ваша фигура может быть перевернутой или нет}
 
 {Строится правильный многоугольник с количеством сторон n, на основании k-ой
  сторооны m-того многоугольника в глобальном массиве}
 var v:integer;
     fi,fi1:real;
     rx,ry,r,xi,yi,r1:real;
     x1,y1,x,y:real;
     flag:boolean;
begin
  {Это особый случай, когда надо нарисовать место склейки}
  flag:=false;  
  if n=-1 then
    begin
        flag:=true;
        n:=3;
    end
  else;
  
  {Получаем координаты k-ой стороны m-го многоугольника}
  if m<>-1 then
    begin
      x:=t[m].a[k].x; y:=t[m].a[k].y;
      x1:=t[m].a[k+1].x; y1:=t[m].a[k+1].y;
    end
  else
   {Если нет ни одного многоугольника то делаем так}
   begin
    x:=0; y:=0; x1:=size; y1:=0;
   end;
  
  {Забиваем данные в ячейку}
  if flag then t[i].n:=4
  else         t[i].n:=n;
  t[i].m:=m;
  t[i].k:=k;
  
  {Строим многоугольник в ячейку}
  {Находим координаты центра}
	rx:=(x1+x)/2+((cos(pi/n)/sin(pi/n))*(y1-y))/2;
	ry:=(y1+y)/2-(cos(pi/n)/sin(pi/n)*(x1-x))/2;
	
	{Находим угол наклона многоугольника}
	if (y1=y) or (x1=x) then fi:=pi/n
	else                     fi:=-arctan((x1-x)/(y1-y))+pi/n;
    	
  if (y1>y) then fi:=fi+pi;

  if y1=y then
    if x1>x then fi:=fi+pi/2
    else         fi:=fi+3*pi/2
  else;
  
  {Находим радиус многоугольника}
   r:=sqrt(sqr(x1-x)+sqr(y1-y))/(2*sin(pi/n));

  {Строим все стороны по очереди}
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
           {Формулы для нахождения координат точек вершин многоугольника, чтобы
            их найти надо знать координаты центра, радиус,и угол наклона, но так
            как мы их нашли,то можно спокойно строить многоугольник, формула взята
            с Википедии}
  	       xi:=rx+r*cos(fi+2*v*pi/n);
  	       yi:=ry+r*sin(fi+2*v*pi/n);

  	       t[i].a[v+1].x:=xi;
  	       t[i].a[v+1].y:=yi;
  	   end;
end;

procedure poly(a:mas; n:integer; cl:color);
{Процедура строит многоугольник согласно массиву а, размером n, заполняя его
 цветом cl}
var
    b:array of Point;
    i:integer;
    cl1:color;
begin
    {Заполняем массив, для того чтоб его потом передать граф. процедуре}
    setlength(b,n);
    for i:=0 to n-1 do
        begin
            b[i].x:=trunc(a[i+1].x);
            b[i].y:=trunc(a[i+1].y);
        end;
     
    {Рисуем благодаря уже имеющейся процедуре}
    cl1:=brushcolor;
    setbrushcolor(cl);
    polygon(b);
    setbrushcolor(cl1);
end;

procedure drawfield;
{Процедура рисует все многоугольники в глобальном массиве, на экран}
var
    i,j:integer;
begin
    {Сначала очищаем область экрана от старой картинки}
    setpencolor(clwhite);
    rectangle(0,0,xmax+20,ymax+20);
    setpencolor(clblack);

    {Перебираем все места склейки}
    for i:=1 to n do
        if T[i].n=-1 then
            {Закрасить многоугольник серым цветом, а если он связан с текущим
             многоугольником, то другими цветами закрасить его}
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
    //Перебираем все многоугольники
    for i:=1 to n do
        if (T[i].n<>0) and (T[i].n<>-1) then
            {Закрасить многоугольник белым цветом, а если он связан с текущим
             многоугольником, то другими цветами закрасить его}
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
{Добавляет в глобальный массив многоугольник с заданными параметрами, в заданное место,
 со смещением остальных элементов}
var
    i:integer;
begin
    {Размеры увеличиваются}
    n:=n+1;
    {Смещаем элементы}
    for i:=n-1 downto a do
        t1[i+1]:=t1[i];
    {Изменяем значения некоторых элементов, смысл которых изменился от смещения}
    for i:=1 to n do 
        if t1[i].m>=a then
            t1[i].m:=t1[i].m+1
        else;
       
    {Заполняем сам элемент в образовавшееся место}
    t1[a].n:=x; t1[a].m:=x1; t1[a].k:=x2;
end;

procedure deleteT(a:integer);
{Удаляет элемент развертки из памяти, под номером m, со смещением остальных элементов}
label start;
var
    i:integer;
begin
    {Удаляем всех его потомков}
    start:
    for i:=1 to n do
        if t1[i].m=a then
            begin
                deleteT(i);
                goto start;
            end
        else;
    
    {Смещаем все предыдущие элементы с перезаписью}
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
{В этой процедуре численные значения преобразуются в координаты}
var
    i:integer;
begin
    {Сначала очищаем массив}
    for i:=1 to 500 do
        t[i].n:=0;    
    
    {Затем выполняем заполнение}
    for i:=1 to n do
        with t1[i] do polygonT(n,m,k,i);
end;

procedure preparing_image;
{Процедура смещает координаты для того чтобы фигура находилось строго в 20 пикселях
 от краев экрана, а так же находит полный размер развертки}
var
    i,j:integer;
begin
    {Находим самые дальние точки фигуры}
    xmin:=0; ymin:=0;
    xmax:=trunc(size); ymax:=0;
    for i:=1 to n do
        {Общий случай, для n-угольников}
        if (T[i].n<>0) and (T[i].n<>-1) then
            {Сравниваем все координаты}
            for j:=1 to T[i].n do
                with t[i].a[j] do
                    begin
                        if x<xmin then xmin:=trunc(x);
                        if y<ymin then ymin:=trunc(y);
                        if x>xmax then xmax:=trunc(x);
                        if y>ymax then ymax:=trunc(y);
                    end
        else
          {Особый случай на место склейки}
          if T[i].n=-1 then
              {Сравниваем все координаты}
              for j:=1 to 4 do
                  with t[i].a[j] do
                      begin
                          if x<xmin then xmin:=trunc(x);
                          if y<ymin then ymin:=trunc(y);
                          if x>xmax then xmax:=trunc(x);
                          if y>ymax then ymax:=trunc(y);
                      end
          else;
    {Смещаем их}
    xmax:=xmax-xmin+20;
    ymax:=ymax-ymin+20;
    
    {Смещаем все точки так, чтобы ни одна точка не выходила за пределы экрана, 
     зная так же самые дальние точки}
    for i:=1 to n do
        if T[i].n<>-1 then
           {Общий случай, для n-угольников}
           for j:=1 to T[i].n+1 do
               begin
                    T[i].a[j].x:=T[i].a[j].x-xmin+20;
                    T[i].a[j].y:=T[i].a[j].y-ymin+20;
               end
        else
            {Особый случай на место склейки}
            for j:=1 to 5 do
                begin
                     T[i].a[j].x:=T[i].a[j].x-xmin+20;
                     T[i].a[j].y:=T[i].a[j].y-ymin+20;
                end;
                
    {Изменяем размеры окна согласно самой дальней точки после смещения}
    sizex:=xmax+20;
    sizey:=ymax+20;
end;

procedure textcenter(s:string);
{Выводит строку s посередине экрана}
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
{ПРоцедура-пустышка, нужна, чтобы ничего не реагировало на события}
begin
end;

procedure addsymbol(key:integer);
{Процедура добавляет по символу в строку s, при выполнении события onkeydown}
begin
    {Записываем буквы и цифры}
    if ((key>64) and (key<91)) or (key=32) or ((key>47) and (key<58)) then
        s:=s+lowcase(chr(key))
    else
        {Кнопка стереть}
        if (key=8) then
            delete(s,length(s),1)
        else
            {Кнопка ввести строку}
            if key=13 then
                begin
                    flag:=true;
                    onkeydown:=vacuum;
                end
            else;
            
     {Выводим значение строки в реальном времени}
     clearwindow;
     textcenter('Please enter a filename for creating:'+chr(10)+' ');
     redraw;
end;

procedure write_mas;
{Процедура выводит числовой массив в открытый файл}
var
    i:integer;
begin
    {Перезаписать файл}
    rewrite(f);
    {Вывести его}
    for i:=1 to n-1 do
        writeln(f,t1[i].n,' ',t1[i].m,' ',t1[i].k);
    i:=i+1;
    write(f,t1[n].n,' ',t1[n].m,' ',t1[n].k);
    {Закрыть файл}
    close(f);
end;
    
procedure loadfile(loaded_file:string);
{Считать файл с названием s}
begin
    {Начальные настройки графики}
    setwindowsize(500,200); clearwindow;
    setwindowtitle('NetCreater v1.07');
    setfontsize(16); setfontname('Courier New');
    
    {Считываем текстовые данные из файла}
    s:=loaded_file;
    {Если файл конечно существует}
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
      {Если нет, то уведомляем пользователя об этом и выключаем программу}
      begin
        clearwindow;
        textcenter('File is not exists.');
        redraw;
        sleep(10000);
        halt;
      end;
end;    
    
procedure enterfile;
{Процедура для ввода имени файла}
begin
    {Делаем начальные действия}
    s:='';
    setwindowsize(500,200); clearwindow;
    setwindowtitle('NetCreater v1.07');
    setfontsize(16); setfontname('Courier New');
    
    {Начальные действия}
    flag:=false;
    textcenter('Please enter a filename for creating:'+chr(10)+' ');
    onkeydown:=addsymbol;
  
    {Каждые 0.5с обновляем информацию на экране и курсор}
    repeat
        sleep(500);
        clearwindow;
        textcenter('Please enter a filename for creating:'+chr(10)+s+'_');
        redraw;
        
        sleep(500);
        clearwindow;
        textcenter('Please enter a filename for creating:'+chr(10)+s+' ');
        redraw;
    {До того,пока не изменится значение флага(пользователь нажмет Ентер)}    
    until flag;
    
    {Добавляем расширение}
    s:=s+'.Net';
    
    delete(s,1,1);
    {Создаем файл с таким именем}
    assign(f,s);

    {Заполняем массив стартовыми данными}
    n:=1;
    t1[1].n:=3;
    t1[1].m:=-1;
    t1[1].k:=0;

    {Выводим эти стартовые данные в массив}
    write_mas;
end;

procedure right_interface;
{Процедура выводит боковой интерфейс с учетом смещения и текущего положения в нем}
var
    i,k,x,y,j:integer;
    s:string;
begin
    {Подготавливаем режимы}
    setpencolor(clwhite);
    rectangle(xmax+20,0,windowwidth,windowheight);
    setpencolor(clblack);
   
    {Цикл рисования бокового интерфейса}
    k:=p-(ymax+20) div (textheight(' ')+7) div 2;
    {Перебираем от поля до указателя, считая его центром, до полей после указателя
     (количество этих полей высчитывается относительно размеров окна)}
    for i:=k to min(n,p+(ymax+20) div (textheight(' ')+7) div 2+3) do
    {Если пустой элемент то не выводим его}
    if t1[i].n<>0 then
        begin
            {Координаты положения текста}
            x:=xmax+20+2+textheight(' ');
            y:=windowheight div 2-textheight(' ')+(i-p)*(textheight(' ')+7);
            
            {Создаем строку с числами,которые надо вывести}
            with t1[i] do s:=tostr1(n)+tostr1(k); {tostr1(m)+}
            
            {Выводим квадратики}
            {Если мы выводим элемент указателя,то выводим его красным}
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
            {Выводим текст}
            textout(x,y,s);
            textout(x+6+textwidth(s),y,tostr1(i));
            setbrushstyle(bssolid);
        end
    else;
    setbrushcolor(clwhite);
end;

procedure polygon_nums;
{Выводим числа в центр фигур, обозначающие номер фигуры в массиве}
var
    i,j,x1,y1:integer;
begin
    {Делаем фон текста прозрачным}
    setbrushstyle(bsclear);
    for i:=1 to n do
        {Не выводим номера мест склейки}
        if t[i].n<>-1 then
          begin
            {Сначала определяем центр фигуры}
            x1:=0;y1:=0;
            for j:=1 to t[i].n do
                begin
                    x1:=x1+trunc(t[i].a[j].x);
                    y1:=y1+trunc(t[i].a[j].y);
                end;

            {Получаем координаты выводимого текста}
            x1:=x1 div t1[i].n;
            y1:=y1 div t1[i].n;
            x1:=x1-textwidth(tostr(i)) div 2;
            y1:=y1-textheight(tostr(i)) div 2;

            {Выводим текст}
            textout(x1,y1,tostr(i));
          end
        else;
    setbrushstyle(bssolid);
end;

procedure render_image;
{Процедура рисует увеличенную версию изображения в канвас, и сохраняет его как
 картинку}
var i,j:integer;
begin
    preparecanvas;
    clearcanvas;
    size:=r_size;
    
    {Создаем координаты вершин каждого многоугольника}
    sspap;
    
    {Производим смещение и узнаем максимальные размеры}
    preparing_image;
    
    sizex:=xmax+20; sizey:=ymax+20;
    
    {Перебираем все многоугольники}
    for i:=1 to n do
        {Особый случай для места склейки}
        if T[i].n=-1 then
            begin 
                outpoly(t[i].a,5,argb(255,200,200,200));
                for j:=1 to 4 do
                    with t[i] do
                    lineout(a[j].x,a[j].y,a[j+1].x,a[j+1].y);                
            end
        else;        
    for i:=1 to n do
        {Общий случай для n-угольников}
        if (T[i].n<>0) and (T[i].n<>-1) then
            begin
                outpoly(t[i].a,t[i].n+1,argb(255,255,255,255));
                for j:=1 to T[i].n do
                    with t[i] do
                    lineout(trunc(a[j].x),a[j].y,a[j+1].x,a[j+1].y);
            end
        else;

    {Сохраняем файл}
    savecanvas(s);
    
    {Возвращаем былой размер}
    size:=o_size;
    
    {Готовим координаты для будущего рисования в окно, не увеличенной версии}
    sspap;
    preparing_image;    
end;

procedure editText(key:integer);
label start2;
var i:integer;
{Процедура редактирования фигуры в реальном времени,при помощи нажатия клавиш}
begin
    {Программа особо лагает в этой процедуре, поэтому уведомим пользователя, что
     происходит}
    setwindowtitle('Loading...');
    
    {Обрабатываем разные клавиши вроде передвижения, изменения значения, сохранения,
     удаления и добавления элемента}
    case key of
        {Передвижение по интерфейсу}
        vk_up: if p<>1 then p:=p-1;
        vk_down: if p<>n then p:=p+1;
        vk_right: if px<>2 then px:=px+1 else;
        vk_left: if px<>1 then px:=px-1 else;
        vk_end: p:=n;
        vk_home: p:=1;
        
        vk_back: begin 
                 if p<>1 then begin deleteT(p); p:=p-1; end else;
                 if p>n then p:=n;
                 {Создаем координаты вершин каждого многоугольника}
                 sspap;
    
                 {Производим смещение и узнаем максимальные размеры}
                 preparing_image;
                 end;
        
        187,107:begin
                    case px of
                        1: if t1[p].n=-1 then t1[p].n:=3 else if t1[p].n<>32 then t1[p].n:=t1[p].n+1;
                        2: if (t1[p].k<>t1[t1[p].m].n) and (t1[p].k<>0) then t1[p].k:=t1[p].k+1;
                    end;
                    {Вычисляем координаты,сдвиг и максимумы}
                    sspap;
                    preparing_image;
                end;
        189,109:begin
                    case px of
                        1: if t1[p].n=3 then t1[p].n:=-1 else if t1[p].n<>-1 then t1[p].n:=t1[p].n-1 else;
                        2: if (t1[p].k<>1) and (t1[p].k<>0) then t1[p].k:=t1[p].k-1;
                    end;
                    {Если мы понизили стороны полигона, а на не существующей стороне
                     остались ещё построенные фигуры, если такие есть, то удаляем их
                     и их потомков, и начинаем всё сначала, потому что потомков могло
                     быть много и где угодно}
                    start2:
                    for i:=2 to n do
                        if t1[t1[i].m].n<t1[i].k then
                           begin
                             deleteT(i);
                             goto start2;
                           end
                        else;

                    {Вычисляем координаты,сдвиг и максимумы}
                    sspap;
                    preparing_image;
                end;

        {Добавляет элемент, на позицию +1 от текущей, и строится он на многоугольнике,
         на котором вы только что стояли, причем нельзя строить на месте склейки}
        vk_a:  if t1[p].n<>-1 then
                   begin
                    addT(p+1,3,p,1);
                    p:=p+1;

                    {Вычисляем координаты,сдвиг и максимумы}
                    sspap;
                    preparing_image;
                   end
               else;
               
        {Сохраняем числа в сопряженный файл}
        vk_s: write_mas;
       
        {Рендерим развертку в более больщом формате}
        vk_r: begin sizeX:=xmax*r_size div o_size+20; sizey:=ymax*r_size div o_size+20; render_image; end;
        
        {Настраиваем размеры текущей картинки, на пять пикселей, эта длина -
         длина стороны}
        vk_p: if o_size<200 then begin o_size:=o_size+5; size:=o_size; sspap; preparing_image; end;
        vk_i: if o_size<>25 then begin o_size:=o_size-5; size:=o_size; sspap; preparing_image; end;
        
        {Настраиваем размеры картинки при рендеринге,на пять пикселей, эта длина
         - длина стороны}
        vk_t: if r_size<400 then r_size:=r_size+5;
        vk_e: if r_size<>25 then r_size:=r_size-5;
        
        {Настраиваем размеры шрифта}
        vk_g: begin f_size:=f_size+1; setfontsize(f_size); sspap; preparing_image; end;
        vk_d: if f_size<>5 then begin f_size:=f_size-1; setfontsize(f_size); sspap; preparing_image; end;
    end;
    
    {Настраиваем окно в соответствии с максимальным размером}
    setwindowsize(xmax+20+textwidth('            ')+textheight(' '),ymax+20);
    
    {Рисуем развертку}
    drawfield;
    
    {Рисуем боковой интерфейс}
    right_interface;
    
    {Выводим номера фигур на самих фигурах}
    polygon_nums;
    
    redraw;
    {Возвращаем обычный заголовок, чтобы пользователь знал, что долгая операция 
     окончена}
    setwindowtitle('NetCreater v1.07  o_size:' + tostr(o_size)+'  r_size:'+tostr(r_size)+'  f_size:'+tostr(f_size));
end;

begin
    {Подготавливаем канвас для будущего рендеринга}
    pensizeset(1.3); f_size:=8; o_size:=60; r_size:=300; size:=o_size;
    
    {Начальные настройки графики}
    lockdrawing; setfontname('Courier New'); setsmoothingoff; SetWindowIsFixedSize(true);
    
    {Ввод имени файла}
    if paramcount=0 then enterfile
    else                 loadfile(paramstr(1));
    
    {Начальные действия}
    clearwindow;setfontsize(f_size); p:=1; px:=1;
    t1[1].n:=t1[1].n-1;
    edittext(187);
    
    {По нажатию клавиши делаем определенные действия}
    onkeydown:=edittext;
end.
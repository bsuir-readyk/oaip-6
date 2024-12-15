const N = 6;
Type TGraphMatrix = array[1..N] of array[1..N] of integer;
Type TArr = array[1..100] of integer;

var GRAPH: TGraphMatrix =
{
(
  (0, 1, 1, 1, 1, 1),
  (1, 0, 1, 1, 1, 1),
  (1, 1, 0, 1, 1, 1),
  (1, 1, 1, 0, 1, 1),
  (1, 1, 1, 1, 0, 1),
  (1, 1, 1, 1, 1, 0)
);
}
{
(
  (0, 0, 0, 1, 1, 1),
  (0, 0, 1, 1, 1, 1),
  (0, 1, 0, 1, 1, 1),
  (1, 1, 1, 0, 1, 1),
  (1, 1, 1, 1, 0, 1),
  (1, 1, 1, 1, 1, 0)
);
}
{
(
  (0, 0, 0, 0, 1, 1),
  (0, 0, 1, 1, 0, 0),
  (0, 1, 0, 1, 1, 1),
  (0, 1, 1, 0, 1, 1),
  (1, 0, 1, 1, 0, 1),
  (1, 0, 1, 1, 1, 0)
);
}
{
(
  (0, 0, 0, 1, 1, 1),
  (0, 0, 0, 1, 1, 1),
  (0, 0, 0, 1, 1, 1),
  (1, 1, 1, 0, 0, 0),
  (1, 1, 1, 0, 0, 1),
  (1, 1, 1, 0, 1, 0)
);
}
{
(
  (0, 1, 0, 0, 0, 0),
  (1, 0, 1, 0, 0, 0),
  (0, 1, 0, 1, 0, 0),
  (0, 0, 1, 0, 1, 0),
  (0, 0, 0, 1, 0, 1),
  (0, 0, 0, 0, 1, 0)
);
}
{
(
  (0, 0, 0, 0, 0, 0),
  (0, 0, 0, 0, 0, 0),
  (0, 0, 0, 0, 0, 0),
  (0, 0, 0, 0, 0, 0),
  (0, 0, 0, 0, 0, 0),
  (0, 0, 0, 0, 0, 0)
);
}

(
  (0, 1, 1, 1, 0, 0),
  (1, 0, 1, 1, 0, 0),
  (1, 1, 0, 1, 0, 0),
  (0, 1, 1, 0, 1, 1),
  (0, 0, 0, 1, 0, 1),
  (0, 0, 0, 1, 1, 0)
);


// Функция нахождения максимальной клики
function FindMaxClick(GRAPH: TGraphMatrix; k, x: integer; var maxVer: integer; curVers: TArr; var maxCL, curCl: TArr): TArr;
var
  i, j, p, l: integer;
  curVers2: TArr;
  b: boolean;
begin
  if ((k = 1) or (k = 0)) then
    FindMaxClick := curCL
  else
  begin
    i := 1;
    b := false;
    while (i < k) do
    begin
      if (i > 1) then
      begin
        if (b) then
        begin
          x := x-1;
          b := false;
        end;
        curCl[x-1] := curVers[i];
      end;
      j := i + 1;
      p := 1;
      while (j <= k) do
      begin
        if (GRAPH[curVers[i], curVers[j]] = 1) then
          begin
            curVers2[p] := curVers[j];
            p := p + 1;
          end;
        j := j + 1;
      end;
      if (p <> 1) then
      begin
        b := True;
        curCl[x] := curVers2[1];
        x := x + 1;
        curCl := FindMaxClick(GRAPH, p-1, x, maxVer, curVers2, maxCl, curCl);
      end;
      if (maxVer < x-1) then
      begin
        maxVer := x-1;
        for l := 1 to maxVer do
          maxCl[l] := curCl[l];
      end;
      i := i + 1;
    end;
    FindMaxClick := maxCl;
  end;
end;

var
  i, j, k, x, l, h: integer;
  maxVer, maxVerRemember, numMaxCl: integer;
  curCl, maxCl, curVers, maxClNew: TArr;
begin
  i := 1;
  maxVerRemember := 1;
  maxCl[1] := 1;
  numMaxCl := 0;
  while (i < N) do
  begin
    // Онуление прошлых элементов
    for l := 1 to N do
      curVers[l] := 0;
    for l := 3 to N do
      curCl[l] := 0;
    curCl[1] := i;
    j := i + 1;
    k := 1;

    // Нахождение соседей
    repeat
      if (GRAPH[i, j] = 1) then
        begin
          curVers[k] := j;
          k := k + 1;
        end;
      j := j + 1;
    until (j > N);
    if (curVers[1] <> 0) then
    begin
      curCl[2] := curVers[1];
      maxVer := 2;
      x := 3;
      maxClNew := curCl;

      maxClNew := FindMaxClick(GRAPH, k-1, x, maxVer, curVers, maxClNew, curCl);

      // Обновление максимальной клики
      if (maxVerRemember < maxVer) then
      begin
        maxVerRemember := maxVer;
        numMaxCl := maxVerRemember;
        maxCl := maxClNew;
      end
      else if ((maxVerRemember = maxVer) and (i <> 1)) then
      begin
        for l := numMaxCl+1 to numMaxCl + maxVerRemember do
          maxCl[l] := maxClNew[l - numMaxCl];
        numMaxCl := numMaxCl + maxVerRemember;
      end;
    end;
    i := i + 1;
  end;

  // Вывод максимальной клики
  if (maxVerRemember = 1) then
    for l := 1 to N do
    writeln(l)  
  else if (maxVerRemember < numMaxCl) then
  begin
    j := numMaxCl div maxVerRemember;
    for h := 0 to j-1 do
    begin
      for l := h * maxVerRemember+1 to maxVerRemember*h + maxVerRemember do
        write(maxCl[l]);
      writeln;
    end;
  end
  else
  for l := 1 to maxVerRemember do
    write(maxCl[l]);
  readln;
end.


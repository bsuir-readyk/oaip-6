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

function FindMaxClick(GRAPH: TGraphMatrix; k, x: integer; var maxVer: integer; curVers: TArr; var maxCL, curCl: TArr): TArr;
var
  i, j, p, l: integer;
  curVers2: TArr;
  b: boolean;
begin
  if ((k = 1) or (k = 0)) then
  begin
    FindMaxClick := curCL;
  end
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
          Dec(x);
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
          Inc(p);
        end;
        Inc(j);
      end;

      if (p <> 1) then
      begin
        b := True;
        curCl[x] := curVers2[1];
        Inc(x);
        curCl := FindMaxClick(GRAPH, p-1, x, maxVer, curVers2, maxCl, curCl);
      end;

      if (maxVer < x-1) then
      begin
        maxVer := x-1;
        l := 1;
        while (l <= maxVer) do
        begin
          maxCl[l] := curCl[l];
          Inc(l);
        end;
      end;
      Inc(i);
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
    l := 1;
    while (l <= N) do
    begin
      curVers[l] := 0;
      Inc(l);
    end;

    l := 3;
    while (l <= N) do
    begin
      curCl[l] := 0;
      Inc(l);
    end;

    curCl[1] := i;
    j := i + 1;
    k := 1;

    while (j <= N) do
    begin
      if (GRAPH[i, j] = 1) then
      begin
        curVers[k] := j;
        Inc(k);
      end;
      Inc(j);
    end;

    if (curVers[1] <> 0) then
    begin
      curCl[2] := curVers[1];
      maxVer := 2;
      x := 3;
      maxClNew := curCl;

      maxClNew := FindMaxClick(GRAPH, k-1, x, maxVer, curVers, maxClNew, curCl);

      if (maxVerRemember < maxVer) then
      begin
        maxVerRemember := maxVer;
        numMaxCl := maxVerRemember;
        maxCl := maxClNew;
      end
      else
      begin
        if ((maxVerRemember = maxVer) and (i <> 1)) then
        begin
          l := numMaxCl + 1;
          while (l <= numMaxCl + maxVerRemember) do
          begin
            maxCl[l] := maxClNew[l - numMaxCl];
            Inc(l);
          end;
          numMaxCl := numMaxCl + maxVerRemember;
        end;
      end;
    end;
    Inc(i);
  end;

  if (maxVerRemember = 1) then
  begin
    l := 1;
    while (l <= N) do
    begin
      writeln(l);
      Inc(l);
    end;
  end
  else
  begin
    if (maxVerRemember < numMaxCl) then
    begin
      j := numMaxCl div maxVerRemember;
      h := 0;
      while (h < j) do
      begin
        l := h * maxVerRemember + 1;
        while (l <= maxVerRemember * h + maxVerRemember) do
        begin
          write(maxCl[l]);
          Inc(l);
        end;
        writeln;
        Inc(h);
      end;
    end
    else
    begin
      l := 1;
      while (l <= maxVerRemember) do
      begin
        write(maxCl[l]);
        Inc(l);
      end;
    end;
  end;
end.


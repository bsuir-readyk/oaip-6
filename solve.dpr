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

function FindMaxClick(
  GRAPH: TGraphMatrix;
  k, x: integer;
  var currentMaxCliqueSize: integer;
  neighbors: TArr;
  var maxCL, curCl: TArr
): TArr;
var
  i, j, p, l: integer;
  newNeighbors: TArr;
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
        curCl[x-1] := neighbors[i];
      end;

      j := i + 1;
      p := 1;

      while (j <= k) do
      begin
        if (GRAPH[neighbors[i], neighbors[j]] = 1) then
        begin
          newNeighbors[p] := neighbors[j];
          Inc(p);
        end;
        Inc(j);
      end;

      if (p <> 1) then
      begin
        b := True;
        curCl[x] := newNeighbors[1];
        Inc(x);
        curCl := FindMaxClick(GRAPH, p-1, x, currentMaxCliqueSize, newNeighbors, maxCl, curCl);
      end;

      if (currentMaxCliqueSize < x-1) then
      begin
        currentMaxCliqueSize := x-1;
        l := 1;
        while (l <= currentMaxCliqueSize) do
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
  currentMaxCliqueSize, globalMaxCliqueSize, numMaxCl: integer;
  curCl, maxCl, neighbors, maxClNew: TArr;
begin
  i := 1;
  globalMaxCliqueSize := 1;
  maxCl[1] := 1;
  numMaxCl := 0;

  while (i < N) do
  begin
    l := 1;
    while (l <= N) do
    begin
      neighbors[l] := 0;
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
        neighbors[k] := j;
        Inc(k);
      end;
      Inc(j);
    end;

    if (neighbors[1] <> 0) then
    begin
      curCl[2] := neighbors[1];
      currentMaxCliqueSize := 2;
      x := 3;
      maxClNew := curCl;

      maxClNew := FindMaxClick(GRAPH, k-1, x, currentMaxCliqueSize, neighbors, maxClNew, curCl);

      if (globalMaxCliqueSize < currentMaxCliqueSize) then
      begin
        globalMaxCliqueSize := currentMaxCliqueSize;
        numMaxCl := globalMaxCliqueSize;
        maxCl := maxClNew;
      end
      else
      begin
        if ((globalMaxCliqueSize = currentMaxCliqueSize) and (i <> 1)) then
        begin
          l := numMaxCl + 1;
          while (l <= numMaxCl + globalMaxCliqueSize) do
          begin
            maxCl[l] := maxClNew[l - numMaxCl];
            Inc(l);
          end;
          numMaxCl := numMaxCl + globalMaxCliqueSize;
        end;
      end;
    end;
    Inc(i);
  end;

  if (globalMaxCliqueSize = 1) then
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
    if (globalMaxCliqueSize < numMaxCl) then
    begin
      j := numMaxCl div globalMaxCliqueSize;
      h := 0;
      while (h < j) do
      begin
        l := h * globalMaxCliqueSize + 1;
        while (l <= globalMaxCliqueSize * h + globalMaxCliqueSize) do
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
      while (l <= globalMaxCliqueSize) do
      begin
        write(maxCl[l]);
        Inc(l);
      end;
    end;
  end;
end.

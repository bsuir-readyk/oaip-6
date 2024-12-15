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


function FindMaxClique(
  graph: TGraphMatrix;
  neighborCount: integer;
  cliquePosition: integer;
  var currentMaxCliqueSize: integer;
  neighbors: TArr;
  var maximalClique, currentClique: TArr
): TArr;
var
  currentNeighborIndex, nextNeighborIndex, newNeighborCount, copyIndex: integer;
  newNeighbors: TArr;
  foundNewClique: boolean;
begin
  if ((neighborCount = 1) or (neighborCount = 0)) then
  begin
    FindMaxClique := currentClique;
  end
  else
  begin
    currentNeighborIndex := 1;
    foundNewClique := false;
    
    while (currentNeighborIndex < neighborCount) do
    begin
      if (currentNeighborIndex > 1) then
      begin
        if (foundNewClique) then
        begin
          Dec(cliquePosition);
          foundNewClique := false;
        end;
        currentClique[cliquePosition-1] := neighbors[currentNeighborIndex];
      end;

      // Find mutual neighbors
      nextNeighborIndex := currentNeighborIndex + 1;
      newNeighborCount := 1;

      while (nextNeighborIndex <= neighborCount) do
      begin
        if (graph[neighbors[currentNeighborIndex], 
                 neighbors[nextNeighborIndex]] = 1) then
        begin
          newNeighbors[newNeighborCount] := neighbors[nextNeighborIndex];
          Inc(newNeighborCount);
        end;
        Inc(nextNeighborIndex);
      end;

      // If mutual neighbors found, extend clique
      if (newNeighborCount > 1) then
      begin
        foundNewClique := True;
        currentClique[cliquePosition] := newNeighbors[1];
        Inc(cliquePosition);
        
        currentClique := FindMaxClique(
          graph, 
          newNeighborCount-1, 
          cliquePosition,
          currentMaxCliqueSize,
          newNeighbors,
          maximalClique,
          currentClique
        );
      end;

      // Update maximal clique if current is larger
      if (currentMaxCliqueSize < cliquePosition-1) then
      begin
        currentMaxCliqueSize := cliquePosition-1;
        copyIndex := 1;
        while (copyIndex <= currentMaxCliqueSize) do
        begin
          maximalClique[copyIndex] := currentClique[copyIndex];
          Inc(copyIndex);
        end;
      end;
      Inc(currentNeighborIndex);
    end;
    FindMaxClique := maximalClique;
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

      maxClNew := FindMaxClique(GRAPH, k-1, x, currentMaxCliqueSize, neighbors, maxClNew, curCl);

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


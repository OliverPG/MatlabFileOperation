function R=shiftN(mat,n,direction)
%20200430
%n: digits shift
%dim: 'row' tread mat as one row (or 'r',2)
%dim: 'column' treat mat as one column (or 'c',1)
%direction: can be 'left' 'right' 'up' 'down' 1 2
if strcmp(direction,'left') || strcmp(direction,'right')
    R=mat';
elseif strcmp(direction,'up') || strcmp(direction,'down')
    R=mat;
else
    fprintf("\n\tshiftN(): The direction should be one of 'left','right','up','down'.\n");
end
if strcmp(direction,'up') || strcmp(direction,'left')
    R=[R(n+1:end,:);R(1:n,:)];
elseif strcmp(direction,'down') || strcmp(direction,'right')
    R=[R(end-n+1:end,:);R(1:end-n,:)];
end
if strcmp(direction,'left') || strcmp(direction,'right')
    R=R';
end
end

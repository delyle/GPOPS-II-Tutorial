function Idx = find_closest(xq,x,max_indices)
% FIND_CLOSEST This function finds the index Idx of x such that x(Idx) is 
%              closest to xq.
%   xq = the value of interest.
%   x  = the array to search
%   max_indices = the maximum number of indices that the user wants, should
%                 there be multiple values of x that are equally close to
%                 n (default is to return all indices).

[~, Idx] = min(abs(x-xq));
if nargin < 3
   max_indices = length(Idx); 
elseif length(Idx) < max_indices
    max_indices = length(Idx);
end
Idx = Idx(1:max_indices);
end
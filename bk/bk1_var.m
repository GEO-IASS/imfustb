function [b_map, d_map]=bk1_var(a, w)

fun=inline('repmat((std2(x)).^2, size(x))');
std_a=blkproc(a, size(w), floor(size(w)/2), fun);
b_map=std_a;
%d_map=b_map;
[b_map, d_map]=ut_prpmp(b_map, jet(256), size(a));


% [b_map, d_map]=ut_prpmp(b_map, jet(256), size(a));
function [res] = tracking_push_relabel_main2(dres, c_en, c_ex, cij, betta)

dnum = length(dres.x);
c_en    = c_en    *1e6;  %%% The mex function works with large numbers.
c_ex    = c_ex    *1e6;
dres.c = betta - dres.r; %% cost for each detection window 
dres.c  = dres.c  *1e6;
n_nodes = 2*dnum+2; %% number of nodes in the graph

dat_in = zeros(1e4,3); %% each row represents an edge from node in column 1 to node in column 2 with cost in column 3.
k_dat = 0;
for i = 1:dnum
  k_dat = k_dat+3;
  dat_in(k_dat-2,:) = [1      2*i     c_en      ];
  dat_in(k_dat-1,:) = [2*i    2*i+1   dres.c(i) ];
  dat_in(k_dat,:)   = [2*i+1  n_nodes c_ex      ];
end

% [v1,v2]=find(c_ij ~=100);

% for ind=1:length(v1)
% for i=1:dnum
%   for j = i+1:dnum
%     k_dat = k_dat+1;
% %     i=v1(ind,1);
% %     j=v2(ind,1);
%     dat_in(k_dat,:) = [2*i+1 2*j c_ij(i,j)];
%   end
% end

for i=1:dnum
%     j = c_ij(i,1);
    arr = cij(i).nei;
    value = cij(i).val;
    for p=1:length(arr)
        j = arr(p);
        if(j~=0)
            k_dat = k_dat+1;
            dat_in(k_dat,:) = [2*i+1 2*j 1/value(p)*1e6];
        end
    end
end

dat_in = [dat_in repmat([0 1],size(dat_in,1),1)];  %% add two columns: 0 for min capacity in column 4 and 1 for max capacity in column 5 for all edges.

excess_node = [1 n_nodes];  %% push flow in the first node and collect it in the last node.

k = 0;
dat2_old = [0 0 0];

inds_all = [];
tic
lb=1;
% ub=1e3+200;
ub = dnum*2-3;
tr_num_old = 1;

tic

while ub-lb > 1     %% bisection search for the optimum amount of flow. This can be implemented by Golden section search more efficiently.
  tr_num = round((lb+ub)/2);
%   display(tr_num);

  [cost_l, dat_l] = cs2_func(dat_in(1:k_dat,:), excess_node, [tr_num -tr_num]);      %% try flow = tr_num
  [cost_u, dat_u] = cs2_func(dat_in(1:k_dat,:), excess_node, [tr_num+1 -tr_num-1]);  %% try flow = tr_num+1
  if cost_u-cost_l > 0
    ub = tr_num;
  else
    lb = tr_num;
  end
  k=k+1;
end

if cost_u < cost_l
  dat1 = dat_u;
else
  cost1 = cost_l;
  dat1 = dat_l;
end

%%%% backtrack tracks to get ids
tmp   = find( dat1(:, 1) == 1);
start = dat1(tmp, 2);       %% starting nodes; is even 
% display(length(start));
% end
tmp   = find( ~mod(dat1(:, 1), 2) .* (dat1(:, 2)-dat1(:, 1) == 11) );
detcs = dat1(tmp, 1);       %% detection nodes; is even

tmp   = find( mod(dat1(:, 1), 2) .* ~mod(dat1(:, 2), 2) .* (dat1(:, 2)-dat1(:, 1) ~= 1) );
links = dat1(tmp, 1:2);     %% links; is [odd even] for cij, [even odd] for det cost

res_inds  = zeros(1, 1e5);
res_ids   = zeros(1, 1e5);

k = 0;
for i = 1:length(start);    %% for each track
  this1 = start(i);
  while this1 ~= n_nodes
    k = k+1;
    res_inds(k) = this1/2;
    res_ids(k) = i;
    this1 = links(links(:,1) == this1+1, 2);  %% should have only one value
    if mod(this1, 2) + (length(this1) ~= 1)         %% sanity check
      display('error in the output of solver');
    end
  end
end
res_inds  = res_inds(1:k);    %% only these detection windows are used in tracks.
res_ids   = res_ids(1:k);     %% track id for each detection window

%%% Calculate the cost value to sort tracks
% this_cost = zeros(1, max(res_ids));
for i = 1:max(res_ids)  %% for each track
  inds = res_ids == i;
%   len1= length(inds);
%   track_cost(i) = sum(dres.c(res_inds(inds))) + (len1-1) * c_ij + c_en + c_ex;
  track_cost(i) = sum(dres.c(res_inds(inds)))  + c_en + c_ex;
%   pp = res_inds(inds);
%   for k1=1:length(pp)-1
%       node1 = pp(k1);
%       node2 = pp(k1+1);
%       track_cost(i) = track_cost(i) + c_ij(node1,node2);
%   end
end
[~ ,sort_inds] = sort(track_cost);

for i = 1:length(sort_inds)
  res_ids_sorted(res_ids == sort_inds(i)) = i;
end

res = sub(dres, res_inds);
res.id = res_ids_sorted(:);

% [dummy tmp] = sort(res.id);
% res = sub(res,tmp);
% % res = sub(dres,inds_all_its(1).inds);
% % res.r = res.r/1e6;


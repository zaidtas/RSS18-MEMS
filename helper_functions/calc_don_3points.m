function [don, switch_value] = calc_don_3points(box,n_points)
if (n_points>8)
    
    for i=1:30
    [block_1_ind, block_2_ind , ~]=dividerand(n_points,0.5,0.5,0);
    block1=box(:,block_1_ind(1:4));
    block2=box(:,block_2_ind(1:4));
    
    n1 = fitNormal(block1');
    n2 = fitNormal(block2');
    don_arr(i)=abs(atan2d(norm(cross(n1,n2)),dot(n1,n2)));
    end
    deg_more=find(don_arr>90);
    don_arr(deg_more)=180-don_arr(deg_more);
    don=max(don_arr);
    switch_value=1;
    
else
    don=0;
    switch_value=0;
end
end
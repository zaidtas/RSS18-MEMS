function [don, switch_value] = calc_don(box,n_points)
if (n_points>6)
    
    for i=1:10
    [block_1_ind, block_2_ind , ~]=dividerand(n_points,0.5,0.5,0);
    block1=box(:,block_1_ind);
    block2=box(:,block_2_ind);
    
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
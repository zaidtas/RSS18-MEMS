function [dom, switch_value] = calc_dom(box,n_points)
if (n_points>3)
    dom_arr=zeros(1,6);
    for i=1:12
    [block_1_ind, block_2_ind , ~]=dividerand(n_points,0.5,0.5,0);
    block1=box(:,block_1_ind);
    block2=box(:,block_2_ind);
    
    block1_mean=mean(block1,2);
    block2_mean=mean(block2,2);
    
    dom_arr(i)=sqrt(sum((block1_mean-block2_mean).^2));
    end
    dom=median(dom_arr);
    switch_value=1;
    
else
    dom=0;
    switch_value=0;
end
end
function [ICS]=calc_ICS(thetacheck,omegacheck)
rcheck=1;
load small_box

[xcheck,ycheck,zcheck]=find_x_y_z_try1(thetacheck,omegacheck,rcheck);

directioncheck=[xcheck,ycheck,zcheck];
index_small_box=find(theta_box>(thetacheck-1) & theta_box<(thetacheck+1) & ...
    omega_box>(omegacheck-1) & omega_box<(omegacheck+1));

%this becomes zeros(1,
theta_omega_check_ctr=0;
origin=[0,0,0];

% figure;
% hold on;
% grid on;
% scatter3(x,y,z,'b.');
% 
% % origin
%     text(origin(1), origin(2), origin(3), 'origin');
%     plot3(origin(1), origin(2), origin(3), 'k.', 'MarkerSize', 10);
% 
%     % direction
%     quiver3(origin(1), origin(2), origin(3), directioncheck(1), directioncheck(2), directioncheck(3), 5);
    
    
    
%index_small_box(i)
for i=1:length(index_small_box)
    
[flag(i) ,tmin{i}] = rayBoxIntersection([0,0,0], directioncheck, v_min{index_small_box(i)}, v_max{index_small_box(i)});

intersection = origin + tmin{i}*directioncheck;
r_value_of_intersection(i)=norm(intersection);
r_box_initial(i)=norm(midpoint{index_small_box(i)});
% if(flag(i)==1)
%      vertices = [v_max{index_small_box(i)}(1) v_min{index_small_box(i)}(2)...
%          v_min{index_small_box(i)}(3); v_max{index_small_box(i)}(1) v_max{index_small_box(i)}(2)...
%          v_min{index_small_box(i)}(3); v_min{index_small_box(i)}(1) v_max{index_small_box(i)}(2) ...
%          v_min{index_small_box(i)}(3); v_min{index_small_box(i)}(1) v_max{index_small_box(i)}(2) ...
%          v_max{index_small_box(i)}(3); v_min{index_small_box(i)}(1) v_min{index_small_box(i)}(2) ...
%          v_max{index_small_box(i)}(3); v_max{index_small_box(i)}(1) v_min{index_small_box(i)}(2) ...
%          v_max{index_small_box(i)}(3); v_min{index_small_box(i)}; v_max{index_small_box(i)} ];
%     faces = [1 2 3 7; 1 2 8 6; 1 6 5 7; 7 5 4 3; 2 8 4 3; 8 6 5 4];
%     h= patch('Vertices',vertices,'Faces',faces,'FaceColor','green');
%     set(h,'FaceAlpha',0.5);
%   
%     
% 
%     % intersection 
%     plot3(intersection(1), intersection(2), intersection(3), 'r.', 'MarkerSize', 15);
%     
% end

end

% view(60,30);
%     axis tight;
%     xlabel('x');
%     ylabel('y');
%     zlabel('z');
%%
%  intersectionpoints=intersection{fin
r_values=r_value_of_intersection(find(flag));
boxnumbers=index_small_box(find(flag));
r_boxes=[0 r_box_initial(find(flag))];
[~,sortind]=sort(r_values);

prob_of_occupancy_sorted=prob_xyz(boxnumbers(sortind));
prob_ej(1)=prod(1-prob_of_occupancy_sorted);
prob_ej(2)=prob_of_occupancy_sorted(1);
for i=2:length(sortind)
    prob_ej(i+1)=prod(1-prob_of_occupancy_sorted(1:i-1))*prob_of_occupancy_sorted(i);
end

sigma=0.1;
mean=0;

cardinality=length(prob_ej);
w(1)=prob_ej(1)^2;
w(cardinality)=prob_ej(cardinality)^2;

for i=2:(cardinality-1)
    w(i)=(prob_ej(i)^2)*prod(prob_of_occupancy_sorted(i:(cardinality-1)).^2+...
        (1-prob_of_occupancy_sorted(i:(cardinality-1))).^2);
end

first_term=log10(sum(w*normpdf(0,mean,sigma)));

second1=prod(prob_of_occupancy_sorted(1:(cardinality-1)).^2+...
        (1-prob_of_occupancy_sorted(1:(cardinality-1))).^2);
    
mul=repmat(r_boxes,cardinality,1);
muj=repmat(r_boxes',1,cardinality);

mudist=abs(mul-muj);
matrix_normpdf=normpdf(mudist,mean,sigma);
second2=sum(sum((prob_ej'*prob_ej).*matrix_normpdf));

secondterm=log10(second1*second2);

thirdterm=-2*log10(sum(sum((w'*prob_ej).*mudist)));

ICS=first_term+secondterm+thirdterm;
end
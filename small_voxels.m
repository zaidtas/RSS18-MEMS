%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tesselate into smaller voxels and calculate relevant values for each voxel
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
close all

%% Load Paths and data
path(path,'./helper_functions');
load big_boxes.mat

%% Fixed tesselation parameters

div_x=0.1;
div_y=0.1;
div_z=0.1;

n_bins_x=ceil((max_x-min_y)/div_x);
n_bins_y=ceil((max_y-min_y)/div_y);
n_bins_z=ceil((max_z-min_z)/div_z);

x_ind=ceil((x-min_x)/div_x);
y_ind=ceil((y-min_y)/div_y);

% boxes(count).y_ind=ones(length(boxes(count).x_ind),1);
z_ind=ceil((z-min_z)/div_z);

x_zero=find(x_ind==0);
x_ind(x_zero)=1;

y_zero=find(y_ind==0);
y_ind(y_zero)=1;

z_zero=find(z_ind==0);
z_ind(z_zero)=1;


% boxes(count).omega_theta{i,j,k}=zeros(1,1000); %points
n_points_arr=zeros(n_bins_x,n_bins_y,n_bins_z);
%box can be preallocated
boxes=cell(n_bins_x,n_bins_y,n_bins_z);

for count2=1:length(x(:))
   boxes{x_ind(count2),y_ind(count2),z_ind(count2)}(:,n_points_arr(x_ind(count2),y_ind(count2) ...
       ,z_ind(count2))+1)=[x(count2),y(count2),z(count2)];
   n_points_arr(x_ind(count2),y_ind(count2),z_ind(count2)) ...
       =n_points_arr(x_ind(count2),y_ind(count2),z_ind(count2))+1;
end


midpoint=cell(n_bins_x,n_bins_y,n_bins_z);
theta=zeros(n_bins_x,n_bins_y,n_bins_z);
omega=zeros(n_bins_x,n_bins_y,n_bins_z);
%% probabilility and then theta and omega(which comes from midpoint)
for i=1:n_bins_x
    for j=1:n_bins_y
        for k=1:n_bins_z
            midpoint{i,j,k}=[i*div_x+min_x-div_x/2 j*div_y+min_y-div_y/2 k*div_z+min_z-div_z/2];
            [~,theta_box(i,j,k),omega_box(i,j,k)]=cartesian_to_polar(midpoint{i,j,k}(1),midpoint{i,j,k}(2),midpoint{i,j,k}(3));
                    
            distance_vector= sqrt((x-midpoint{i,j,k}(1)).^2+(y-midpoint{i,j,k}(2)).^2+(z-midpoint{i,j,k}(3)).^2);
%             [M]=max(distance_vector);
            distance_nearest_xyz(i,j,k)=min(distance_vector);
            prob_xyz(i,j,k)=exp(-5*distance_nearest_xyz(i,j,k));
            
            v_min{i,j,k}=midpoint{i,j,k}-[div_x/2 div_y/2 div_z/2];
            v_max{i,j,k}=midpoint{i,j,k}+[div_x/2 div_y/2 div_z/2];
        end
    end
end

save small_box.mat theta_box omega_box v_min v_max midpoint prob_xyz
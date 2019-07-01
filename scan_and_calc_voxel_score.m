%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Scan the point cloud at a given resolution
% Tesselate the point cloud into bigger voxels
% Calculate the complexity of each voxel using residuals from PCA
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
close all

%% Load Paths
path(path,'./helper_functions');
path(path,'./fitNormal');

%% Fixed Parameters

%Sensor's FOV
thetamaxorig=20;
thetaminorig=-20;

omegamaxorig=20;
omegaminorig=-20;

%% Variable Parameters
% Base scan resolution
n_bins_theta=50;
n_bins_omega=50;

% Voxel dimensions
div_x=0.25;
div_y=0.25;
div_z=0.5;

%% Load a ground truth(GT) point cloud which is a high resolution dense scan
load('gt_dense_scan.mat','vector_scan');

% calc the angle the ray from the the sensor origin makes with each point in the GT scan

[dirn_with_z]= calc_dirn_with_z(vector_scan);

%% Scan the scene at a base resolution in this example 50*50

[xstream,ystream,del_theta,del_omega] = generate_raster(n_bins_theta,n_bins_omega);

omegastream=(omegamaxorig+omegaminorig)/2+(omegamaxorig-omegaminorig)/2*ystream;
thetastream=(thetamaxorig+thetaminorig)/2+(thetamaxorig-thetaminorig)/2*xstream;

save stream_for_base_CSQMI.mat omegastream thetastream
% SCAN!

for i=1:length(omegastream)
    [x(i) y(i) z(i)]=mems_scan_x_y_z(vector_scan,thetastream(i),omegastream(i),dirn_with_z);
    
end

%% Tesselate into Voxels

base_total_points=length(x);

max_x=max(x);
max_y=max(y);
max_z=max(z);

min_x=min(x);
min_y=min(y);
min_z=min(z);

% parameters: change these by max and min of all the scans 
xplus=max_x;
xminus=min_x;

yplus=max_y;
yminus=min_y;

zplus=max_z;
zminus=min_z;


%%




n_bins_x=ceil((xplus-xminus)/div_x);
n_bins_y=ceil((yplus-yminus)/div_y);
n_bins_z=ceil((zplus-zminus)/div_z);

div_x=(xplus-xminus)/n_bins_x;
div_y=(yplus-yminus)/n_bins_y;
div_z=(zplus-zminus)/n_bins_z;

x_ind=ceil((x-xminus)/div_x);
y_ind=ceil((y-yminus)/div_y);
z_ind=ceil((z-zminus)/div_z);

% Fix edge points
x_zero=find(x_ind==0);
x_ind(x_zero)=1;

y_zero=find(y_ind==0);
y_ind(y_zero)=1;

z_zero=find(z_ind==0);
z_ind(z_zero)=1;

n_points_arr=zeros(n_bins_x,n_bins_y,n_bins_z);
%box can be preallocated
boxes=cell(n_bins_x,n_bins_y,n_bins_z);

for count2=1:length(x(:))
   boxes{x_ind(count2),y_ind(count2),z_ind(count2)}(:,n_points_arr(x_ind(count2),y_ind(count2) ...
       ,z_ind(count2))+1)=[x(count2),y(count2),z(count2)];
   n_points_arr(x_ind(count2),y_ind(count2),z_ind(count2)) ...
       =n_points_arr(x_ind(count2),y_ind(count2),z_ind(count2))+1;
end

%% Calc complexity score on the boxes
 for i=1:n_bins_x
    for j=1:n_bins_y
        for k=1:n_bins_z
            
            [don_initial_scan(i,j,k),~]=calc_don(boxes{i,j,k},n_points_arr(i,j,k));          
[dom_initial_scan(i,j,k), switch_value_initial_scan(i,j,k)]=calc_dom(boxes{i,j,k},n_points_arr(i,j,k));
if n_points_arr(i,j,k)>1
    clear ax bx cz
ax=boxes{i,j,k}(1,:);
ay=boxes{i,j,k}(2,:);
az=boxes{i,j,k}(3,:);

pca_scan{i,j,k}=pcares([ax' ay' az'],2);
sq_pca{i,j,k}=sqrt(sum(pca_scan{i,j,k}'.^2));

pca_box(i,j,k)=mean(sq_pca{i,j,k});


end
        end 
    end
 end
 
%% Save the tesselation data
 save('big_boxes.mat','boxes','n_points_arr','dirn_with_z','vector_scan', ...
     'max_x','max_y','max_z','min_x','min_y','min_z','n_bins_x','n_bins_y','n_bins_z','dom_initial_scan',...
     'don_initial_scan','switch_value_initial_scan','div_x','div_y','div_z' , 'pca_box','del_theta','del_omega',...
     'thetamaxorig','thetaminorig','omegamaxorig','omegaminorig','x','y','z');
 
 
 
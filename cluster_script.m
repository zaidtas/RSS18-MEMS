%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load the tesselated voxels with their complexity scores
% Cluster based on spatial proximity and complexity scores
% Calculate the complexity of each voxel using residuals from PCA
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
close all

%% Load Paths and Data
path(path,'./helper_functions');

load big_boxes.mat

%% dependent params
div_thetax=del_theta;
div_omegay=del_omega;

save_data=1;
plot_fig=1;
%% Parameters for clustering

kmeans_k=4;

index=find(n_points_arr>5);

% don=don_initial_scan(index)/90*12;
pca=pca_box(index);

[indexi,indexj,indexk]=ind2sub([n_bins_x,n_bins_y,n_bins_z],index);

ok=find(indexk<10);
indexk=indexk(ok);
indexj=indexj(ok);
indexi=indexi(ok);
pca=pca(ok);

i_max=max(indexi);
i_min=min(indexi);

indexinew =((indexi-i_min)*(1)/(i_max-i_min));

j_max=max(indexj);
j_min=min(indexk);

indexjnew =((indexj-j_min)*(1)/(j_max-j_min));

k_max=max(indexk);
k_min=min(indexk);

indexknew =((indexk-k_min)*(1)/(k_max-k_min));

pca_max=max(pca);
pca_min=min(pca);

pcanew =((pca-pca_min)*(0.1)/(pca_max-pca_min));

index=[indexinew,indexjnew,indexknew,pcanew];
% ok=find(indexk<12);
% indexk=indexk(ok);
% indexj=indexj(ok);
% indexi=indexi(ok);
% idex=rescale([indexi,indexj,indexk,don]);

[idx,C]=kmeans(index,kmeans_k,'Distance','sqeuclidean');

if plot_fig==1
    figure
    
    hold on
    for i=1:length(idx);
        if(idx(i)==1)
            x=boxes{indexi(i),indexj(i),indexk(i)}(1,:);
            y=boxes{indexi(i),indexj(i),indexk(i)}(2,:);
            z=boxes{indexi(i),indexj(i),indexk(i)}(3,:);
            scatter3(x,y,z,'r.');
        elseif(idx(i)==2)
            x=boxes{indexi(i),indexj(i),indexk(i)}(1,:);
            y=boxes{indexi(i),indexj(i),indexk(i)}(2,:);
            z=boxes{indexi(i),indexj(i),indexk(i)}(3,:);
            scatter3(x,y,z,'b.');
        elseif(idx(i)==3)
            x=boxes{indexi(i),indexj(i),indexk(i)}(1,:);
            y=boxes{indexi(i),indexj(i),indexk(i)}(2,:);
            z=boxes{indexi(i),indexj(i),indexk(i)}(3,:);
            scatter3(x,y,z,'g.');
        elseif(idx(i)==4)
            x=boxes{indexi(i),indexj(i),indexk(i)}(1,:);
            y=boxes{indexi(i),indexj(i),indexk(i)}(2,:);
            z=boxes{indexi(i),indexj(i),indexk(i)}(3,:);
            scatter3(x,y,z,'k.');
            
        elseif(idx(i)==5)
            x=boxes{indexi(i),indexj(i),indexk(i)}(1,:);
            y=boxes{indexi(i),indexj(i),indexk(i)}(2,:);
            z=boxes{indexi(i),indexj(i),indexk(i)}(3,:);
            scatter3(x,y,z,'m.');
        elseif(idx(i)==6)
            x=boxes{indexi(i),indexj(i),indexk(i)}(1,:);
            y=boxes{indexi(i),indexj(i),indexk(i)}(2,:);
            z=boxes{indexi(i),indexj(i),indexk(i)}(3,:);
            scatter3(x,y,z,'c.');
            
        end
    end
end

if save_data==1
 save clustered_voxels.mat
end

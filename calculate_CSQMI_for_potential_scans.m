%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load the clustered data 
% Asssign weight based on FOV and complexity
% Calc CSQMI value based on potential scanning trajectories in each ROI
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
close all

%% Load Paths and Data
path(path,'./helper_functions');
path(path,'./rayBoxIntersection');

load clustered_voxels.mat

%% Defining point budget and background complexity 
total_points=sum(sum(sum(n_points_arr(:,:,:)))); 
final_points=0.6*total_points;


%for background it's hardcoded by observation
new_don(kmeans_k+1)=10;

omegamax(kmeans_k+1)=omegamaxorig;
omegamin(kmeans_k+1)=omegaminorig;
thetamax(kmeans_k+1)=thetamaxorig;
thetamin(kmeans_k+1)=thetaminorig;

% 
for kindex=1:kmeans_k
    box_ind=find(idx==kindex);
    x=[];
    y=[];
    z=[];
    for box_ctr=1:length(box_ind)
           i=indexi(box_ind(box_ctr));
           j=indexj(box_ind(box_ctr));
           k=indexk(box_ind(box_ctr));
          
                 x=[x boxes{i,j,k}(1,:)];
                 y=[y boxes{i,j,k}(2,:)];
                 z=[z boxes{i,j,k}(3,:)];
                 
    end        
        
                 [~,theta,omega]=cartesian_to_polar(x,y,z);
                 
                 thetamax(kindex)=max(theta);
                 thetamin(kindex)=min(theta);
                 omegamax(kindex)=max(omega);
                 omegamin(kindex)=min(omega);
                 
                 box_bin{kindex}=[x;y;z];
%                  interest(kindex)=(thetamax(kindex)-thetamin(kindex))*(omegamax(kindex)-omegamin(kindex))/...
%                      (thetamaxorig-thetaminorig)/(omegamaxorig-omegaminorig);
                 
                 n_points_bin(kindex)=length(x);
                 
                 new_don(kindex)=calc_don_3points(box_bin{kindex},n_points_bin(kindex));
                 
end

%just for don, we can do clamp and square
% factors_div=new_don/sum(new_don(:));
%% Calculate score based on Difference of normal complexity, you can add

for i=1:kmeans_k+1
    factor_div(i)=sqrt(new_don(i)/sum(new_don(:))*final_points/(omegamax(i)- ...
        omegamin(i))/(thetamax(i)-thetamin(i)));
    
    if(i<4)
    [thetastream{i},omegastream{i}]=each_roi_stream(thetamin(i),thetamax(i) ...
        ,omegamin(i),omegamax(i),factor_div(i));
    end
end
%%
for i=1:3
    for j=1:3
        for k=1:3
            
          theta_probable{i,j,k}=[thetastream{1}{i} thetastream{2}{j} thetastream{3}{k}];
          omega_probable{i,j,k}=[omegastream{1}{i} omegastream{2}{j} omegastream{3}{k}];
          
          
         
          CSQMI(i,j,k)=calc_CSQMI(theta_probable{i,j,k},omega_probable{i,j,k})/length(theta_probable{i,j,k});
    
        end
        
    end
    
    
end
A=CSQMI(:);
plot(A)
          [new_value, sort_ind]=sort(CSQMI(:));
          
          %%
          close all
 figure
 for i=1:3
     
     plot(theta_probable{sort_ind(i)},omega_probable{sort_ind(i)})
     hold on
     plot(theta_probable{sort_ind(i)},omega_probable{sort_ind(i)},'o');
 end

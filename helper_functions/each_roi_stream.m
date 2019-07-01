% function [x,y,z]=each_box_simulation_raster(thetamin,thetamax,omegamin,omegamax,div_x, ...
%     div_y,factor_div,vector_scan,dirn_with_z)
% [theta,omega]=calc_theta_omega_stream_raster(thetamin,thetamax,omegamin,omegamax,interest,total_time);


%generate 3 scans for each factor_div
function [theta,omega]=each_roi_stream(thetamin,thetamax,omegamin,omegamax,factor_div)
load gt_dense_scan
%%
% thetamin=-5;
% thetamax=5;
% 
% omegamin=-5;
% omegamax=5;
%phase 0 is edge and phase 1 is middle
% phase =1;
load big_boxes div_x div_y

% factor_div=1;

% load dense_scene_scan.mat

div_x=div_x/factor_div;
div_y=div_y/factor_div;

thetaminx=thetamin/20;
thetamaxx=thetamax/20;
omegaminy=omegamin/20;
omegamaxy=omegamax/20;

xy_div_ctr=1;

for phase=1:1

for xy_div_ctr=1:3
    if xy_div_ctr==1
        n_bins_x=floor((thetamaxx-thetaminx)/div_x);
        n_bins_y=floor((omegamaxy-omegaminy)/div_y);
    elseif xy_div_ctr==2
        n_bins_x=floor((thetamaxx-thetaminx)/div_x*2);
        n_bins_y=floor((omegamaxy-omegaminy)/div_y/2);
    else
             
        n_bins_x=floor((thetamaxx-thetaminx)/div_x/2);
        n_bins_y=floor((omegamaxy-omegaminy)/div_y*2);
    end
        
if phase==1

div_x_new=(thetamaxx-thetaminx)/(n_bins_x-1);
div_y_new=(omegamaxy-omegaminy)/(n_bins_y-1);

div_x_phase=0;
div_y_phase=0;

else
    div_x_new=(thetamaxx-thetaminx)/(n_bins_x);
div_y_new=(omegamaxy-omegaminy)/(n_bins_y);
div_x_phase=div_x_new/2;
div_y_phase=div_y_new/2;

end

base=1;

xstream=[];
ystream=[];

yflag=1;
%one means don't flip
for i=1:(n_bins_x)
   ybase=[]; 
    for j=1:(n_bins_y)
        
        
        xstream=[xstream ((i-1)*div_x_new+thetaminx+div_x_phase)*base];
        ybase=[ybase ((j-1)*div_y_new+omegaminy+div_y_phase)*base];
        
%         ystream=[ystream ((j-1)*div_y+yminus+div_y/2)*base];
    end
  if(yflag==1)
      ystream=[ystream ybase];
      yflag=0;
      
  else
      ystream=[ystream fliplr(ybase)];
      yflag=1;
  end
end

% figure
% plot(xstream,ystream,'o')
% hold on
% plot(xstream,ystream)
% figure
% plot(xstream)
% hold on
% plot(ystream)

% omega=(omegamax+omegamin)/2+(omegamax-omegamin)/2*ystream;
% theta=(thetamax+thetamin)/2+(thetamax-thetamin)/2*xstream;
omega{phase,xy_div_ctr}=20*ystream;
theta{phase,xy_div_ctr}=20*xstream;
end
end
% 
% for i=1:length(omega)
%     [x1(i) y1(i) z1(i)]=mems_scan_x_y_z(vector_scan,theta(i),omega(i),dirn_with_z);
%  
% end
% figure
% scatter3(x1,y1,z1,'ro')
% hold on
% scatter3( vector_scan(:,1),vector_scan(:,2),vector_scan(:,3),'b.')
end
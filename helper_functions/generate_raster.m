function [xstream,ystream,del_theta,del_omega] = generate_raster(theta_bins,omega_bins)

n_bins_theta=theta_bins-1;
n_bins_omega=omega_bins-1;

%here it as a plane normal to sensor z axis
xplus=1;
xminus=-1;

yplus=1;
yminus=-1;

del_theta=(xplus-xminus)/n_bins_theta;
del_omega=(yplus-yminus)/n_bins_omega;

%%
base=1;

xstream=[];
ystream=[];

yflag=1;
%one means don't flip
for i=1:(n_bins_theta+1)
   ybase=[]; 
    for j=1:(n_bins_omega+1)
        
        
        xstream=[xstream ((i-1)*del_theta+xminus)*base];
        ybase=[ybase ((j-1)*del_omega+yminus)*base];
        
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

end
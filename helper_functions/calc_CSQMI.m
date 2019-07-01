function [CQSMI]=calc_CSQMI(thetastream,omegastream)
% clear
% thetastream=theta_probable{1, 1};
% omegastream=omega_probable{1,1};
load ICS_stream_base.mat

angle_diff=0.1;
for az=1:length(thetastream)
    
thetacheck=thetastream(az);
omegacheck=omegastream(az);
index_stream=find(thetastreambase>(thetacheck-angle_diff) & thetastreambase<(thetacheck+angle_diff) & ...
    omegastreambase>(omegacheck-angle_diff) & omegastreambase<(omegacheck+angle_diff));

if(length(index_stream)>1)
    ICS_cal(az)=mean(ICS(index_stream));
else
ICS_cal(az)=calc_ICS(thetacheck,omegacheck);

end
end
CQSMI=sum(ICS_cal);
end

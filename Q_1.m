M=[1 100 1000];  
phi_0=45;
phi_1=-180:1:180; %Create a range of angles from -180 to 180
dH=1/2;
g=zeros(length(M),length(phi_1)); % Initialize a matrix to store the calculated values of g

% Calculate the g function for each combination of M and phi_1
for i =1:length(M)
    for j=1:length(phi_1)
        if phi_1(j)==phi_0 || phi_1(j)==180-phi_0
            g(i,j)=M(i);
        else
            theta=sind(phi_1(j))-sind(phi_0);
            k=sind(180*dH*M(i)*theta)/sind(180*dH*theta);
            g(i,j)=(k*k)/M(i);
        end
       
    end
   
end

 %Plot the g function for different M values
 semilogy(phi_1,g(1,:),'--',DisplayName="M=1");
 hold on
 semilogy(phi_1,g(2,:),'--',DisplayName="M=100");
 x=semilogy(phi_1,g(3,:),'--',DisplayName="M=1000");
 x.Color="green";

 % Set plot limits and labels
 ylim([10^-7 10^3]);
 xlim([-181 181]);
 xlabel('Interfering UE angle(\psi^0_{1})',FontWeight='bold',FontSize=12);
 ylabel('g(\psi^0_{0},\psi^0_{1})',FontWeight='bold',FontSize=12);
 legend('show',Location='best');
 title('Interference plot for LoS channel with MIMO BS', 'fontweight','bold', 'fontsize', 10);
 hold off
 grid on
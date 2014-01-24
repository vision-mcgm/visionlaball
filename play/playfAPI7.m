filled=zeros(1,200);
clear sums;

clear Cadj;

for n=1:100
    file=['C:\Users\PaLS\Desktop\fintan\VisualStudio\TestAppConsole C++_copy(working)\data\mangan\a_mask' num2str(n) '.txt']
    
    C=importdata(file);
    [Cr Cc]=size(C);
    for i=1:Cr
        
        idx=round(C(i,1));
        Cadj(idx,:)=C(i,2:end); %Cadj holds coordinates
        
        if C(i,2) ~= 0
            filled(i)=1;
        end
    end
    
    sums(n)=sum(filled);
    
end
function [Mx,My] = fieldmat(envimat)
    k=10;
    [m,n]=size(envimat);
    walls=envimat==ones(m,n);
    free=envimat==2*ones(m,n);
    Mx=zeros(m,n);
    My=zeros(m,n);
    Mx(:,1)=k;
    Mx(:,end)=-k;
    My(1,:)=k;
    My(end,:)=-k;
    for i=2:m-1
        for j=2:n-1
            Mx(i,j)=k*(walls(i,j-1)-walls(i,j+1));
            My(i,j)=k*(walls(i-1,j)-walls(i+1,j));
        end
    end
    Mx=imgaussfilt(Mx,5).*walls+imgaussfilt(Mx,3).*free;
    My=imgaussfilt(My,5).*walls+imgaussfilt(My,3).*free;
%     Mx=imfilter(Mx,fspecial('disk',10), 'replicate');
%     My=imfilter(My,fspecial('disk',10), 'replicate');
end
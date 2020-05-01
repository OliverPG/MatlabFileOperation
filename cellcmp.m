function R=cellcmp(cellA,cellB)
[rA,cA]=size(cellA);
[rB,cB]=size(cellB);
r=min([rA,rB]);
c=min([cA,cB]);
R=zeros(r,c);
for ir=1:r
    for ic=1:c
        if strcmp(class(cellA{ir,ic}),class(cellB{ir,ic}))
            switch class(cellA{ir,ic})
                case 'char'
                    R(ir,ic)=strcmp(cellA{ir,ic},cellB{ir,ic});
                case 'float'
                    R(ir,ic)=(cellA{ir,ic}-cellB{ir,ic});
                case 'int'
                    R(ir,ic)=(cellA{ir,ic}-cellB{ir,ic});
                otherwise
                    fprintf('\n\tcellcmp(): R(%d,%d) is not a number or char.',ir,ic);
            end
        else
            R(ir,ic)=0;
        end
    end
end
R=logical(R);
end
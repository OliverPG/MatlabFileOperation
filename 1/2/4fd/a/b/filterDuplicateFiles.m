clc;clear;tic;
boolName=0;
boolBytes=1;
boolDate=0;
% filterDir='E:\0_Program\Origin\';
filterDir='E:\GitHub\';
fileObjs=hereFiles(filterDir);
fprintf('\n\tFile list get!');
nameList={fileObjs.name};nameList1=nameList;
bytesList=[fileObjs.bytes];bytesList1=bytesList;
datenumList=[fileObjs.datenum];datenumList1=datenumList;
lenList=length(nameList);
ncmp=(rem(lenList,2)==0).*(lenList/2)+(rem(lenList,2)==1).*ceil(lenList/2);
dupIndex=[];
for i=1:ncmp
    nameList1=shiftN(nameList1,1,'left');
    bytesList1=shiftN(bytesList1,1,'left');
    datenumList1=shiftN(datenumList1,1,'left');
    cmpNames=cellcmp(nameList,nameList1);
    cmpBytes=~(bytesList1-bytesList);
    cmpDates=~(datenumList1-datenumList);
    cmpBool=(cmpNames|(~boolName))&(cmpBytes|(~boolBytes))&(cmpDates|(~boolDate));
    indexTrue=find(cmpBool'==true);
    fprintf('\n\t%d / %d',i,ncmp);
    if isempty(indexTrue)
        continue;
    else
    indexT=indexTrue+i;
    newDupIndex=[indexTrue,(indexT<=lenList).*indexT+(indexT>lenList).*rem(indexT,lenList)];
    dupIndex=[dupIndex;newDupIndex];
    end
end
[rDup,cDup]=size(dupIndex);
dupIndexC=mat2cell(dupIndex,ones(rDup,1),cDup);
if numel(dupIndex)>numel(unique(dupIndex))
    dupN=numel(dupIndex)-numel(unique(dupIndex));
    countN=0;
    indexDup=2;
    while indexDup<=rDup
        indexDD=indexDup;
        while indexDD<=rDup
            if numel(unique([dupIndexC{indexDD},dupIndexC{indexDD-indexDup+1}]))<numel(dupIndexC{indexDD})+numel(dupIndexC{indexDD-indexDup+1})
                uniqueCombine=unique([dupIndexC{indexDD},dupIndexC{indexDD-indexDup+1}]);
                dupIndexC{indexDD}=uniqueCombine;
                dupIndexC(indexDD-indexDup+1)=[];
                countN=countN+1;
            else
                indexDD=indexDD+1;
            end            
            [rDup,~]=size(dupIndexC);
            if countN==dupN
                break;
            end
        end
        indexDup=indexDup+1;  
        if countN==dupN
            break;
        end
    end      
end   
fprintf('\n\tProgram Done!\n');
toc; 
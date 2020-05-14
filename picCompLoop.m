clear;clc;
recycle('on');
global	index index1 index2 name1 name2
global  n1 n2 longName1 longName2 indexList fileOb workDir
global flagPic1 flagPic2 flagSave flagDel1 flagDel2 flagClose
global flagRd1 flagRd2
flagClose=0;
% workDir='E:\0_Program\Python\WebDo\nm_nmcsym\';
workDir='E:\0_Program\Python\WebDo\t\';
sType='jpg';
[fileOb,flagOb]=hereFile(workDir,sType);
[rOb,cOb]=size(fileOb);
if 0
    for index=1:cOb
        newName=[num2str(index),'.jpg'];
        newLName=fullfile(fileOb(index).folder,newName);
        movefile(fullfile(fileOb(index).folder,fileOb(index).name),newLName,'f');
        fileOb(index).name=newName;
        fprintf('\n%d/%d',index,cOb);
    end
end
if exist([workDir,'jpg.cmp'],'file')
    fprintf('\nLoading jpg.cmp ...');
    indexList=load([workDir,'jpg.cmp']);
    fprintf('\nLoad jpg.cmp done.');
else
    fprintf('\nThere is not jpg.cmp.\nCreating indexList ...');
    indexs=1:1:cOb;
    indexList=nchoosek(indexs,2);
    fprintf('\nCreating indexList done.');
end

[rL,cL]=size(indexList);
while rL~=0 && flagClose==0
    index=randi(rL);
    index1=indexList(index,1);index2=indexList(index,2);
    name1=fileOb(index1).name;name2=fileOb(index2).name;
    [~,sname1,~]=fileparts(name1);[~,sname2,~]=fileparts(name2);
    n1=str2double(sname1);n2=str2double(sname2);
    longName1=fullfile(fileOb(index1).folder,name1);
    longName2=fullfile(fileOb(index2).folder,name2);
    pic1=imread(longName1);
    pic2=imread(longName2);
    clf;
    hFig=figure(1);
    hFig.Name=sprintf('length=%d',rL);
    subplot(1,2,1);h1=imshow(pic1);title(sname1);
    subplot(1,2,2);h2=imshow(pic2);title(sname2);
    %Button pic
    h1.ButtonDownFcn={@showCallBack1};
    h2.ButtonDownFcn={@showCallBack2};
    %Button Save
    hSave=uicontrol(hFig,'Style','pushbutton','string','SAVE');
    hSave.Callback={@saveIndexList};
    fPosition=get(gcf,'Position');
    wButton=60;hButton=20;
    xSaveB=fPosition(3)/10-wButton/2;ySaveB=fPosition(4)/13-hButton/2;
    hSave.Position=[xSaveB ySaveB wButton hButton];
    %button Delete
    hDel1=uicontrol(hFig,'Style','pushbutton','string','DEL Left');
    hDel1.Callback={@deleteLeft};
    hDel2=uicontrol(hFig,'Style','pushbutton','string','DEL Right');
    hDel2.Callback={@deleteRight};
    xDel1=fPosition(3)/3-wButton/2;yDel1=fPosition(4)/13-hButton/2;
    xDel2=fPosition(3)/3*2-wButton/2;yDel2=fPosition(4)/13-hButton/2;
    hDel1.Position=[xDel1 yDel1 wButton hButton];
    hDel2.Position=[xDel2 yDel2 wButton hButton];
    %Button Close
    hClose=uicontrol(hFig,'Style','pushbutton','string','Close');
    hClose.Callback={@closePro};
    xClose=fPosition(3)/10*9-wButton/2;yClose=fPosition(4)/13-hButton/2;
    hClose.Position=[xClose yClose wButton hButton];
    %Button Rd
    hRd1=uicontrol(hFig,'Style','pushbutton','string','Rd Left');
    hRd1.Callback={@rdLeft};
    hRd2=uicontrol(hFig,'Style','pushbutton','string','Rd Right');
    hRd2.Callback={@rdRight};
    xRd1=fPosition(3)/3-wButton/2;yRd1=fPosition(4)/13-hButton/2*3;
    xRd2=fPosition(3)/3*2-wButton/2;yRd2=fPosition(4)/13-hButton/2*3;
    hRd1.Position=[xRd1 yRd1 wButton hButton];
    hRd2.Position=[xRd2 yRd2 wButton hButton];
    flagPic1=0;flagPic2=0;flagSave=0;flagDel1=0;flagDel2=0;flagRd1=0;flagRd2=0;
    while ~(flagPic1||flagPic2||flagDel1||flagDel2||flagClose||flagRd1||flagRd2)
        drawnow;
    end
    [rL,cL]=size(indexList);
end
fprintf('\nProgram end!');
close;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function showCallBack1(~,~)
global n1 n2 longName1 longName2 index index1 index2 name1 name2
global indexList fileOb flagPic1
if n1>n2
    if strcmp(fileOb(index1).folder,fileOb(index2).folder)
        movefile(longName2,[pwd,'\cache.jpg'],'f');
        movefile(longName1,fullfile(fileOb(index1).folder,name2),'f');
        movefile([pwd,'\cache.jpg'],fullfile(fileOb(index2).folder,name1),'f');
    else
        movefile(longName1,fullfile(fileOb(index1).folder,name2),'f');
        movefile(longName2,fullfile(fileOb(index2).folder,name1),'f');
    end
    nameCache=fileOb(index1).name;
    fileOb(index1).name=fileOb(index2).name;
    fileOb(index2).name=nameCache;
    indexList(indexList==index1)=index2;
    indexList(indexList==index2)=index1;
end
indexList(index,:)=[];
flagPic1=1;
end
function showCallBack2(~,~)
global n1 n2 longName1 longName2 index index1 index2 name1 name2
global indexList fileOb flagPic2
if n2>n1
    if strcmp(fileOb(index1).folder,fileOb(index2).folder)
        movefile(longName2,[pwd,'\cache.jpg'],'f');
        movefile(longName1,fullfile(fileOb(index1).folder,name2),'f');
        movefile([pwd,'\cache.jpg'],fullfile(fileOb(index2).folder,name1),'f');
    else
        movefile(longName1,fullfile(fileOb(index1).folder,name2),'f');
        movefile(longName2,fullfile(fileOb(index2).folder,name1),'f');
    end
    nameCache=fileOb(index1).name;
    fileOb(index1).name=fileOb(index2).name;
    fileOb(index2).name=nameCache;
    indexList(indexList==index1)=index2;
    indexList(indexList==index2)=index1;
end
indexList(index,:)=[];
flagPic2=1;
end
function saveIndexList(~,~)
global indexList workDir flagSave
fprintf('\nSaving jpg.cmp ...')
save([workDir,'jpg.cmp'],'indexList','-ascii');
fprintf('\nSave jpg.cmp Done.\n');
flagSave=1;
end
function deleteLeft(~,~)
global fileOb indexList index1 longName1 flagDel1
fileOb(index1)=[];
[rCache,~]=find(indexList==index1);
indexList(rCache,:)=[];
rCache=find(indexList>index1);
for ii=rCache
    indexList(ii)=indexList(ii)-1;
end
delete(longName1);
flagDel1=1;
end
function deleteRight(~,~)
global fileOb indexList index2 longName2 flagDel2
fileOb(index2)=[];
[rCache,~]=find(indexList==index2);
indexList(rCache,:)=[];
rCache=find(indexList>index2);
for ii=rCache
    indexList(ii)=indexList(ii)-1;
end
delete(longName2);
flagDel2=1;
end
function closePro(~,~)
global flagClose
global indexList workDir
fprintf('\nSaving jpg.cmp ...')
save([workDir,'jpg.cmp'],'indexList','-ascii');
fprintf('\nSave jpg.cmp Done.\n');
flagClose=1;
end
function rdLeft(~,~)
global flagRd1
global fileOb indexList index1
folderName=fileOb(index1).folder;
rmdir(folderName,'s');
folderList={fileOb.folder};
boolList=strcmp(folderList,folderName);
rdIndex=find(boolList);
fileOb(rdIndex)=[];
for index=1:length(rdIndex)
    [rIndex,~]=find(indexList(:,1)==rdIndex(index));
    indexList(rIndex,:)=[];
    [rIndex,~]=find(indexList(:,2)==rdIndex(index));
    indexList(rIndex,:)=[];
end
oldIndex=setdiff(rdIndex(1):length(folderList),rdIndex);
newIndex=rdIndex(1)-1+1:length(oldIndex);
for index=1:length(oldIndex)
    indexList(indexList==oldIndex(index))=newIndex(index);
end
flagRd1=1;
end
function rdRight(~,~)
global flagRd2
global fileOb indexList index2
folderName=fileOb(index2).folder;
rmdir(folderName,'s');
folderList={fileOb.folder};
boolList=strcmp(folderList,folderName);
rdIndex=find(boolList);
fileOb(rdIndex)=[];
for index=1:length(rdIndex)
    [rIndex,~]=find(indexList(:,1)==rdIndex(index));
    indexList(rIndex,:)=[];
    [rIndex,~]=find(indexList(:,2)==rdIndex(index));
    indexList(rIndex,:)=[];
end
oldIndex=setdiff(rdIndex(1):length(folderList),rdIndex);
newIndex=rdIndex(1)-1+1:length(oldIndex);
for index=1:length(oldIndex)
    indexList(indexList==oldIndex(index))=newIndex(index);
end
flagRd2=1;
end
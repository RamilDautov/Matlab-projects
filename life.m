function life

f=openfig([mfilename '.fig']);
h=guihandles(f);
guidata(f,h);
L=30; % Количество клеток по одному измерению будет (L-1)
X=zeros(L,L); % determination of the grid
pc=pcolor(h.axes,X);
set(pc,'UserData',X,'Facecolor',[0 0 0.58]);
set(h.axes,'XTick',[]);
set(h.axes,'YTick',[]);
set(h.figure,'ResizeFcn',@(x,y)Resize(x));
set(h.start_button,'Callback',@(x,y)Start(x));
set(h.stop_button,'Callback',@(x,y)Stop(x));
set(pc,'ButtonDownFcn',@Click);
set(h.cellnum,'Callback',@(x,y)Cellnum(x));
set(h.clean,'Callback',@(x,y)Clean(x));
set(h.pulsar,'Callback',@(x,y)Pulsar(x));
set(h.starship,'Callback',@(x,y)Starship(x));
set(h.collision,'Callback',@(x,y)Collision(x));
Resize(f);

function Start(hobj)
h=guidata(hobj);
set(h.stop_button,'UserData',[]);
X=get(h.axes,'UserData');
H=size(X,1)-1;
X_N=X;
hold all;
set(h.edit,'ForegroundColor','k');
try x=eval(get(h.edit,'String')); end

err=0;
if ~exist('x') || ~isnumeric(x) || ~isscalar(x) || ~isreal(x) || isnan(x) || isinf(x)...
        || x<=0
    set(h.edit,'ForegroundColor','red'); % текст в поле ввода "Задержка" делаем красным
    err=1;
end
if err, return, end
set(h.start_button,'Enable','off');
while (isempty(get(h.stop_button,'UserData')))
    for j=1:H
        for q=1:H
            sum=0;
            for m=-1:1
                for p=-1:1
                    if (q+p)>0 && q+p<=H
                        if (j+m)>0 && j+m<=H
                            if X(q+p,j+m)==1
                                if abs(m)+abs(p)~=0
                                    sum=sum+1;
                                end;
                            end;
                        end;
                    end;
                end
            end;
            if sum<2 || sum>3
                X_N(q,j)=0;
            else
                if sum==2
                    X_N(q,j)=X(q,j);
                else
                    X_N(q,j)=1;
                end;
            end
        end;
    end;
    pc=pcolor(h.axes,X_N);
    set(h.axes,'XTick',[]);
    set(h.axes,'YTick',[]);
    if X_N==zeros(H+1) %Проверка на то, не опустело ли поле
        warndlg('Game Over!','HA-HA-HA!','modal');
        set(h.start_button,'Enable','on');
set(pc,'UserData',X_N,'ButtonDownFcn',@Click);
return
    else
    X=X_N;
    pause(x);
    end;
end;
set(h.start_button,'Enable','on');
set(pc,'UserData',X_N,'ButtonDownFcn',@Click);

function Stop(hobj)
h=guidata(hobj);
hold all;
set(h.stop_button,'UserData',1);

function Click(hobj, event)
hold all
h=guidata(hobj);
axesHandle=get(hobj,'Parent');
coord=get(axesHandle,'CurrentPoint');
X=get(hobj,'UserData');
pos(1,:)=floor(coord(1,:));
switch X(pos(1,2),pos(1,1))
    case 0
        X(pos(1,2),pos(1,1))=1;
    case 1
        X(pos(1,2),pos(1,1))=0;
end;
set(hobj,'UserData',X);
set(axesHandle,'UserData',X);
pc=pcolor(axesHandle,X);
set(pc,'ButtonDownFcn',@Click,'UserData',X);

function Cellnum(hobj)
h=guidata(hobj);
hold off
answer=inputdlg('Введите количество клеток вдоль одной оси','Создание нового поля', 1, {'1'},'on');
try
    x=eval(answer{1});
end;
if exist('x') && isnumeric(x) && isscalar(x)...
        && isreal(x) && ~isnan(x) && ~isinf(x)...
        && x>0 && round(x)==x
    L=x;
    Y=zeros(L+1);
set(h.axes,'UserData',Y);
pc=pcolor(h.axes,Y);
    set(pc,'ButtonDownFcn',@Click,'UserData',Y,'Facecolor',[0 0 0.58]);
else
    
    errordlg('Не удалось создать поле',...
        'Ошибка создания поля', 'modal');
end
set(h.axes,'XTick',[]);
set(h.axes,'YTick',[]);

function Clean(hobj)
h=guidata(hobj);
X=get(h.axes,'UserData');
H=size(X,1);
X=zeros(H);
 pc=pcolor(h.axes,X);
    set(h.axes,'XTick',[]);
    set(h.axes,'YTick',[]);
    set(pc,'ButtonDownFcn',@Click,'UserData',X);
    
%Samples:
%Sample "Pulsar"
function Pulsar(hobj)
h=guidata(hobj);
L=32;
X=zeros(L);
X(13:19,16)=1;
X(16,15:17)=1;
pc=pcolor(h.axes,X);
hold all;
set(h.axes,'UserData',X);
set(pc,'ButtonDownFcn',@Click,'UserData',X);
set(h.axes,'XTick',[]);
set(h.axes,'YTick',[]);

%Sample "Starship"
function Starship(hobj)
h=guidata(hobj);
L=31;
X=zeros(L);
X(23,5:7)=1;
X(24,7)=1;
X(25,6)=1;
pc=pcolor(h.axes,X);
set(h.axes,'UserData',X);
set(pc,'ButtonDownFcn',@Click,'UserData',X);
set(h.axes,'XTick',[]);
set(h.axes,'YTick',[]);
hold all;

%Sample "Collision of two starships"
function Collision(hobj)
h=guidata(hobj);
L=31;
X=zeros(L);
X(23,5:7)=1;
X(24,7)=1;
X(25,6)=1;
X(12,19:21)=1;
X(11,19)=1;
X(10,20)=1;
pc=pcolor(h.axes,X);
set(h.axes,'UserData',X);
set(pc,'ButtonDownFcn',@Click,'UserData',X);
set(h.axes,'XTick',[]);
set(h.axes,'YTick',[]);
hold all;

function Resize(hobj)
h=guidata(hobj);
fig_pos=get(hobj,'position');
h1=100;
h2=30;
ht=30;
hb=50;
ha=20;
wt=100;
wb=90;
w1=125;
h3=142;
set(h.stop_button,'position',[11 ha wb hb]);
set(h.start_button,'position',[11 ha+h1 wb hb]);
if (fig_pos(4)-h3)>0 && (fig_pos(3)-w1-ha)>0
    set(h.edit,'position',[11 fig_pos(4)-h3 wt ht]);
    set(h.text,'position',[11 fig_pos(4)-h3+h2 wt ht]);
    set(h.axes,'position',[w1 ha (fig_pos(3)-w1-ha) (fig_pos(4)-2*ha)]);
end

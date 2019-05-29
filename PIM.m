%% Pressure Image Manipulation Tool
% Designed and written by Daniel Gibbons.
% Made to visualize and manipulate pressure plate data in .txt format.
% Refer to included instruction manual for operational help.

clear;
clear global;
close force all;
% There are 5 global variables for housing data structures and variables to
% be passed around by functions and buttons.
% S is the structure that houses the buttons, checkboxes, and the whole of
% the Image Tool figure. It is mainly used for the states of check boxes
% and buttons.
% D is the structure which houses only the main data matrix. It contains no
% other data, existing purely for any future flexibility needed in passing
% more desired data.
% A is the structure which houses the auxiliary data which is any numerical
% data other than the main data matrix.
% F is the structure which houses figure reference handles, like the main
% data matrix, the weight text, center of pressure  mapping, etc.
% HB is the structure which houses all of the help box components.
global S;
%% Initialize the buttons, check boxes, edit boxes, and text display in a single global variable S
S.fh = figure('Units','Pixels','Position',[10 100 500 600],...
    'Name','Image Controller','MenuBar','None','Resize','off');

% Title and Version Number
figure(S.fh)
S.tx(1) = uicontrol('Style','Text','Unit','Pixels','Background',get(S.fh,'Color'),...
    'Position',[175 520 150 60],'Fontsize',19,'String',{'P.I.M. Tool','---------------'},...
    'Fontweight','bold');
S.tx(13) = uicontrol('Style','Text','Unit','Pixels','Background',get(S.fh,'Color'),...
    'Position',[290 480 55 40],'Fontsize',12,'String','v1.01');
S.an2 = annotation('rectangle',[0.33 0.85 0.33 0.12]);

% Data Extract and Visualization Section
S.tx(10) = uicontrol('Style','Text','Unit','Pixels','Background',get(S.fh,'Color'),...
    'Position',[5 450 485 20],'Fontsize',10,'String',...
    '_____________________________________________________________');
S.tx(8) = uicontrol('Style','Text','Unit','Pixels','Background',get(S.fh,'Color'),...
    'Position',[150 443 210 20],'Fontsize',10,'String',...
    'Data Extraction and Visualization:');
S.pb(1) = uicontrol('Style','Pushbutton','Units','Pixels','Position',...
    [30 360 100 80],'Fontsize',10,'FontWeight','bold','String','Load File');
S.cb(1) = uicontrol('Style','Checkbox','Units','Pixels','Position',...
    [150 415 150 20],'String','Weight Text','Background',get(S.fh,'Color'),'Enable','inactive');
S.cb(2) = uicontrol('Style','Checkbox','Units','Pixels','Position',...
    [150 390 150 20],'String','Center of Pressure','Background',get(S.fh,'Color'),'Enable','inactive');
S.tx(2) = uicontrol('Style','Text','Unit','Pixels','Background',get(S.fh,'Color'),...
    'Position',[325 390 100 50],'Fontsize',10,'String','Total Number of Frames: ');
S.tx(3) = uicontrol('Style','Text','Unit','Pixels','Background',[0.5 0.5 0.5],...
    'Position',[345 375 50 20],'Fontsize',12,'String','000');
S.pb(2) = uicontrol('Style','Pushbutton','Units','Pixels','Position',...
    [30 260 100 50],'Fontsize',10,'String','Total Force','Enable','inactive');
S.pb(3) = uicontrol('Style','Pushbutton','Units','Pixels','Position',...
    [30 200 100 50],'Fontsize',10,'String','Peak Pressure','Enable','inactive');
S.cb(5) = uicontrol('Style','Checkbox','Units','Pixels','Position',...
    [150 365 150 20],'String','Force/Pressure Graph Track','Background',get(S.fh,'Color'),...
    'Enable','inactive','Visible','on');
S.pb(16) = uicontrol('Style','Pushbutton','Units','Pixels','Enable','inactive','Position',...
    [150 260 100 50],'Fontsize',10,'String','Display MPP');
S.pb(17) = uicontrol('Style','Pushbutton','Units','Pixels','Enable','inactive','Position',...
    [150 200 100 50 ],'Fontsize',10,'String','Display MVP');
S.pb(29) = uicontrol('Style','Pushbutton','Units','Pixels','Enable','inactive','Position',...
    [30 120 150 50],'Fontsize',10,'String','Show Navigation Tools','callback',{@pb_call_29,S},...
    'Enable','inactive');
S.pb(30) = uicontrol('Style','Pushbutton','Units','Pixels','Enable','inactive','Position',...
    [200 120 200 50],'Fontsize',10,'String','Show Data Manipulation Tools','callback',{@pb_call_30,S},...
    'Enable','inactive');
S.pb(31) = uicontrol('Style','Pushbutton','Units','Pixels','Enable','inactive','Position',...
    [30 60 150 50],'Fontsize',10,'String','Show Data Export Tools','callback',{@pb_call_31,S},...
    'Enable','inactive');
S.tx(12) = uicontrol('Style','Text','Unit','Pixels','Background',[0.8 0.8 0.8],...
    'Position',[25 335 450 18],'Fontsize',10,'String',...
    "File Name: ",'HorizontalAlignment','left','FontWeight','bold');

S.an1 = annotation('line','Units','Pixels');
S.an1.X = [25 475];
S.an1.Y = [325 325];

S.an3 = annotation('line','Units','Pixels');
S.an3.X = [25 475];
S.an3.Y = [185 185];

S.pb(15) = uicontrol('Style','Pushbutton','Units','Pixels','Position',...
    [400 10 85 30],'Fontsize',10,'String','Help');
S.pb(23) = uicontrol('Style','Pushbutton','Units','Normalized','Position',...
    [0.10 0.02 0.2 0.05],'Fontsize',10,'String','Reset','visible','off'); % Invisible until functionality is refined
S.pb(24) = uicontrol('Style','Pushbutton','Units','Normalized','Position',...
    [0.32 0.03 0.3 0.03],'Fontsize',10,'String','Save Session','Visible','off'); % Invisible until functionality is refined

%Navigate Options
S.fhNav = figure('Units','Pixels','Position',[540 400 410 250],'Name',...
    'Data Navigation Controller','MenuBar','None','Resize','off','CloseRequestFcn',@fh_call_1);
figure(S.fhNav);
S.tx(5) = uicontrol('Style','Text','Unit','Pixels','Background',get(S.fhNav,'Color'),...
    'Position',[15 215 385 20],'Fontsize',10,'String',...
    '_____________________________________________________________');
S.tx(6) = uicontrol('Style','Text','Unit','Pixels','Background',get(S.fhNav,'Color'),...
    'Position',[165 210 65 20],'Fontsize',10,'String','Navigate:');
S.pb(8) = uicontrol('Style','Pushbutton','Units','Pixels','Position',...
    [50 150 50 30],'Fontsize',10,'String','<<','Enable','inactive');
S.pb(9) = uicontrol('Style','Pushbutton','Units','Pixels','Position',...
    [110 150 50 30],'Fontsize',10,'String','<','Enable','inactive');
S.ed(1) = uicontrol('Style','Edit','Units','Pixels','Position',...
    [170 150 50 30],'Fontsize',10,'String','Frame','Enable','inactive');
S.pb(10) = uicontrol('Style','Pushbutton','Units','Pixels','Position',...
    [230 150 50 30],'Fontsize',10,'String','>','Enable','inactive');
S.pb(11) = uicontrol('Style','Pushbutton','Units','Pixels','Position',...
    [290 150 50 30],'Fontsize',10,'String','>>','Enable','inactive');
S.pb(25) = uicontrol('Style','Pushbutton','Units','Pixels','Position',...
    [130 150 150 30],'Fontsize',10,'String','Return to Single Frame','Visible','Off');
S.pb(14) = uicontrol('Style','Pushbutton','Units','Pixels','Enable','inactive','Position',...
    [70 110 90 30],'Fontsize',10,'String','<= Reverse','Interruptible','on');
S.pb(19) = uicontrol('Style','Pushbutton','Units','Pixels','Enable','inactive','Position',...
    [230 110 90 30],'Fontsize',10,'String','Forward =>','Interruptible','on');
S.pb(26) = uicontrol('Style','Pushbutton','Units','Pixels','Enable','inactive','Position',...
    [170 110 50 30],'Fontsize',10,'String','Stop');
S.sl(1) = uicontrol('Style', 'slider', 'Unit','Pixels','position', [100,25,140,25], ...
    'Min',0.1,'Max',1,'SliderStep',[.05 .05],'Value',0.1,'Enable','inactive');
S.tx(21) = uicontrol('Style','Text','Unit','Pixels','Background',get(S.fhNav,'Color'),...
    'Position',[15 75 385 20],'Fontsize',10,'String',...
    '_____________________________________________________________');
S.tx(17) = uicontrol('Style','Text','Unit','Pixels','Background',get(S.fhNav,'Color'),...
    'Position',[115 65 175 25],'Fontsize',10,'String','Play Speed (seconds/frame):');
S.ed(6) = uicontrol('Style','Edit','Unit','Pixels',...
    'Position',[250 25 50 35],'Fontsize',10,'String','0.100','Enable','inactive');
set(S.fhNav,'Visible','off');

% Manipulate Tools Section
S.fhMan = figure('Units','Pixels','Position',[550 425 500 300],'Name',...
    'Data Manipulation Controller','MenuBar','None','Resize','off','CloseRequestFcn',@fh_call_2);
figure(S.fhMan)
S.tx(4) = uicontrol('Style','Text','Unit','Pixels','Background',get(S.fh,'Color'),...
    'Position',[15 270 475 20],'Fontsize',10,'String',...
    '_____________________________________________________________');
S.tx(9) = uicontrol('Style','Text','Unit','Pixels','Background',get(S.fh,'Color'),...
    'Position',[175 265 125 20],'Fontsize',10,'String',...
    'Manipulation Tools:');
S.pb(4) = uicontrol('Style','Pushbutton','Units','Pixels','Position',...
    [140 220 200 40],'Visible','on','Fontsize',10,'String','Draw Area Tool');
S.pb(20) = uicontrol('Style','Pushbutton','Units','Pixels','Position',...
    [30 175 150 25],'Visible','on','Fontsize',10,'String','Draw Tool Options');
S.pb(21) = uicontrol('Style','Pushbutton','Units','Pixels','Position',...
    [200 175 70 25],'Visible','on','Fontsize',10,'String','Mask');
S.pb(22) = uicontrol('Style','Pushbutton','Units','Pixels','Position',...
    [280 175 70 25],'Visible','on','Fontsize',10,'String','Edit');
S.pu(1) = uicontrol('Style','Popupmenu','Units','Pixels','Position',...
    [370 164 125 35],'String',{'Entire Figure'},'Visible','on');
S.pb(28) = uicontrol('Style','Pushbutton','Units','Pixels','Position',...
    [390 210 70 25],'Visible','on','Fontsize',8,'String','Update','Visible','on');
S.cb(3) = uicontrol('Style','Checkbox','Units','Pixels','Enable','inactive','Position',...
    [280 135 200 25],'Visible','on','String','Highlight Previously Masked Area','Background',get(S.fhMan,'Color'));
S.cb(4) = uicontrol('Style','Checkbox','Units','Pixels','Enable','inactive','Position',...
    [30 135 200 25],'Visible','on','String','Hold CoP Mapping on Frame Change','Background',get(S.fhMan,'Color'));
S.pb(6) = uicontrol('Style','Pushbutton','Units','Pixels','Position',...
    [30 30 200 30],'Visible','on','Fontsize',10,'String','Calculate Local CoP Data');
S.tx(13) = uicontrol('Style','Text','Units','Pixels','Background',get(S.fhMan,'Color'),...
    'Position',[60 105 40 20],'Visible','on','Fontsize',10,'String','Frame');
S.tx(14) = uicontrol('Style','Text','Units','Pixels','Background',get(S.fhMan,'Color'),...
    'Position',[20 60 35 35],'Visible','on','Fontsize',10,'String','From');
S.tx(19) = uicontrol('Style','Text','Units','Pixels','Background',get(S.fhMan,'Color'),...
    'Position',[100 60 35 35],'Visible','on','Fontsize',10,'String','To');
S.tx(20) = uicontrol('Style','Text','Units','Pixels','Background',get(S.fhMan,'Color'),...
    'Position',[140 105 40 20],'Visible','on','Fontsize',10,'String','Frame');
S.ed(4) = uicontrol('Style','Edit','Units','Pixels','Position',...
    [60 70 35 35],'Visible','on','Fontsize',10,'String','B');
S.ed(5) = uicontrol('Style','Edit','Units','Pixels','Position',...
    [140 70 35 35],'Visible','on','Fontsize',10,'String','E');
S.pb(5) = uicontrol('Style','Pushbutton','Units','Pixels','Position',...
    [280 90 200 30 ],'Visible','on','Fontsize',10,'String','Change Selected to Zero');
S.pb(7) = uicontrol('Style','Pushbutton','Units','Pixels','Position',...
    [280 50 200 30],'Visible','on','Fontsize',10,'String','Recalculate CoP Data');
S.pb(32) = uicontrol('Style','Pushbutton','Units','Pixels','Position',...
    [280 10 200 30],'Visible','on','Fontsize',10,'String','Regraph Force/Pressure');
S.tx(18) = uicontrol('Style','Text','Unit','Pixels','Background',[0.8 0.8 0.8],...
    'Position',[150 100 200 55],'Fontsize',10,'FontWeight','bold','String',...
    {'Load Data File Before'; 'Navigating and Manipulating Image.'},'ForegroundColor','b','Visible','off');
set(S.fhMan,'Visible','off');

%Export Options
S.fhExp = figure('Units','Pixels','Position',[560 450 500 300],'Name',...
    'Data Export Controller','MenuBar','None','Resize','off','CloseRequestFcn',@fh_call_3);
figure(S.fhExp)
S.tx(7) = uicontrol('Style','Text','Unit','Pixels','Background',get(S.fh,'Color'),...
    'Position',[15 270 475 20],'Fontsize',10,'String',...
    '_____________________________________________________________');
S.tx(11) = uicontrol('Style','Text','Unit','Pixels','Background',get(S.fh,'Color'),...
    'Position',[175 265 105 20],'Fontsize',10,'String',...
    'Export Options:');
S.pb(27) = uicontrol('Style','Pushbutton','Units','Pixels','Position',...
    [140 220 200 40],'Fontsize',10,'String','Select Destination Directory');
S.tx(15) = uicontrol('Style','Text','Unit','Pixels','Background',[0.8 0.8 0.8],...
    'Position',[30 190 450 20],'Fontsize',10,'String',...
    "Directory: ",'HorizontalAlignment','left','FontWeight','bold');
S.pb(18) = uicontrol('Style','Pushbutton','Units','Pixels','Position',...
    [280 75 200 25],'Visible','on','Fontsize',10,'String','Export New CoP Data');
S.ed(2) = uicontrol('Style','Edit','Units','Pixels','Position',...
    [280 110 200 25],'Visible','on','Fontsize',10,'String','Desired File Name');
S.pb(12) = uicontrol('Style','Pushbutton','Units','Pixels','Position',...
    [30 75 200 25],'Visible','on','Fontsize',10,'String','Export Masked CoP Sequence');
S.ed(3) = uicontrol('Style','Edit','Units','Pixels','Position',...
    [30 110 200 25],'Visible','on','Fontsize',10,'String','Desired File Name');
S.pb(13) = uicontrol('Style','Pushbutton','Units','Pixels','Position',...
    [75 20 350 40],'Visible','on','Fontsize',10,'String','Create Clone of CoP Data Relative to Flash LED');
S.tx(16) = uicontrol('Style','Text','Unit','Pixels','Background',[0.8 0.8 0.8],...
    'Position',[150 100 200 55],'Fontsize',10,'FontWeight','bold','String',...
    {'Select Target Destination Directory'; 'before exporting files.'},'ForegroundColor','b','Visible','off');
set(S.fhExp,'Visible','off');

set(S.pb(1),'callback',{@pb_call_1,S});
set(S.pb(13),'callback',{@pb_call_13,S}); % Give functionality to the Create Relative Clone button
set(S.pb(15),'callback',{@Help_Button,S});
set(S.pb(27),'callback',{@pb_call_27,S});
set(S.pb(20),'callback',{@pb_call_20,S});
set(S.pb(23),'callback',{@pb_call_23,S});
set(S.pb(24),'callback',{@pb_call_24,S});
set(S.pb(32),'callback',{@pb_call_32,S});

%Draw Tool Options Section
global R;
R.fh = figure('Units','Pixels','Position',[535 440 500 300],...
    'Name','Draw Tool Options','MenuBar','None','CloseRequestFcn',@DT_call_2);
R.tx(1) = uicontrol('Style','Text','Unit','Pixels','Background',get(R.fh,'Color'),...
    'Position',[175 225 150 50],'Fontsize',12,'String',...
    'Draw Tool Options','Fontweight','bold');
R.bg = uibuttongroup('Visible','off','Units','Pixels',...
    'Position',[35 90 200 125]);
R.rb(1) = uicontrol(R.bg,'Style','radiobutton','Units','Pixels',...
    'String','Straight Line','Position',[15 80 90 30],...
    'HandleVisibility','off');
R.rb(2) = uicontrol(R.bg,'Style','radiobutton',...
    'String','Free Hand','Units','Pixels',...
    'Position',[15 45 75 30],'HandleVisibility','off');
R.rb(3) = uicontrol(R.bg,'Style','radiobutton','Units','Pixels',...
    'String','Rectangle','Position',[125 80 75 30],...
    'HandleVisibility','off');
R.rb(4) = uicontrol(R.bg,'Style','radiobutton','Units','Pixels',...
    'String','Ellipse','Position',[125 45 75 30],...
    'HandleVisibility','off');
R.rb(5) = uicontrol(R.bg,'Style','radiobutton','Units','Pixels',...
    'String','Point Marker','Position',[70 10 90 30],...
    'HandleVisibility','off');
R.bg.Visible = 'on';
R.cb(1) = uicontrol('Style','Checkbox','Units','Pixels','Position',...
    [265 190 200 30],'String','Apply Image Boundaries','Background',get(R.fh,'Color'));
R.pb(4) = uicontrol('Style','Pushbutton','Units','Pixels','Position',...
    [255 140 150 30],'String','Select Mask Color','Background',get(R.fh,'Color'),...
    'callback',{@DT_call_4});
R.pb(1) = uicontrol('Style','Pushbutton','Units','Pixels','Position',...
    [300 25 100 30],'Fontsize',10,'String','Apply','callback',{@DT_call_1,R});
R.pb(2) = uicontrol('Style','Pushbutton','Units','Pixels','Position',...
    [80 25 100 30],'Fontsize',10,'String','Cancel','callback',{@DT_call_2,R});
R.pb(3) = uicontrol('Style','Pushbutton','Units','Pixels','Position',...
    [255 90 150 30],'Fontsize',8,'String','Clear Point Markers','callback',{@DT_call_3,R});
R.cb(2) = uicontrol('Style','Checkbox','Units','Pixels','Position',...
    [425 90 35 30],'String','Fix','callback',{@DT_call_5,R});
set(R.fh,'Visible','off');

%% This button loads the data file, extracts most of the desired information, and graphs the first frame of data
function [] = pb_call_1(varargin) % Executes when the Load File button is pressed
global S;
global D;
global A;
global F;
[FileName,PathName,~]=uigetfile('*.txt'); % Open a window to select the data text file
if FileName == 0
else
    cd(PathName);
    fid = fopen(FileName); % Open the file
    fn = get(S.tx(12),'String');
    FileName = strcat(fn,{'  '},FileName);
    set(S.tx(12),'String',FileName);
    filecontent = fread(fid); % Read the contents of the file to a variable
    A.frames = readFramelength(filecontent); % Determine the amount of frames
    set(S.tx(3),'String',num2str(A.frames)); % Display the amount of frames on the Image Tool
    [a,b,c,d] = frameLimits(filecontent); % Determine the cropped frame limits
    [D.data,index] = dataExtract(filecontent,A.frames,a,b,c,d); % Extract the main pressure data to a matrix
    [A.MPPmat,index] = readMPP(filecontent,index,a,b,c,d); % Extract the MPP data matrix
    [A.MVPmat,index] = readMVP(filecontent,index,a,b,c,d); % Extract the MVP data matrix
    [A.CoPmat] = readCoP(filecontent,index,A.frames); % Extract the Center of Pressure data matrix
    F.fig2 = figure('Units','normalized','Outerposition',[0.5 0 .5 1],'Name','Visualization'); % Create the figure for the main heat map
    matGraph(1); % Graph the first frame from the main data matrix
    A.curDisplay = 1; %1 for Normal Data, 0 for MPP, -1 for MVP
    set(S.ed(1),'String',num2str(A.CurFrameNum)); % Display the current data frame number in the Navigate Edit Box
    Y_cp = A.CoPmat(:,3);
    X_cp = A.CoPmat(:,2);
    set(0, 'currentfigure', F.fig2); % Make sure the heat map is the current figure
    hold on;
    F.CoPline = plot(2*Y_cp,2*X_cp,'color','k','LineWidth',2); % Graph the Center of Pressure pathway on top of the heat map
    set(S.pb(2),'callback',{@pb_call_2,S}); % Give functionality to the Total Force Button
    set(S.pb(3),'callback',{@pb_call_3,S});% Give functionality to the Peak Pressure Button
    F.curCoP = plot(0,0);
    set(S.cb(1),'Value',0); % Set Weight Text to undisplayed. This is set to 0 for speed purposes and simplicity
    set(S.cb(2),'Value',1); % Set the Center of Pressure to be visible.
    advanceCoP(A.CoPmat,A.CurFrameNum,F.fig2,1); % Graph the current Center of Pressure of the current frame with a red star
    set(S.cb(1),'callback',{@cb_call_1,S}); % Give functionality to the rest of the buttons
    set(S.cb(2),'callback',{@cb_call_2,S});
    set(S.ed(1),'callback',{@ed_call_1,S});
    set(S.pb(4),'callback',{@pb_call_4,S});
    set(S.pb(5),'callback',{@pb_call_5,S});
    set(S.pb(8),'callback',{@pb_call_8,S});
    set(S.pb(9),'callback',{@pb_call_9,S});
    set(S.pb(10),'callback',{@pb_call_10,S});
    set(S.pb(11),'callback',{@pb_call_11,S});
    set(S.pb(16),'callback',{@pb_call_16,S});
    set(S.pb(17),'callback',{@pb_call_17,S});
    set(F.fig2,'KeyPressFcn',{@fh_kpfcn,S});
    set(S.pb(14),'callback',{@pb_call_14,S});
    set(S.pb(19),'callback',{@pb_call_19,S});
    set(S.pb(26),'callback',{@pb_call_26,S});
    set(S.sl(1),'callback',{@sl_call_1,S});
    set(S.sl(1),'value',0.1);
    set(S.ed(6),'callback',{@ed_call_6,S});
    set(S.ed(6),'Enable','on');
    set(S.ed(1),'Enable','on');
    set(S.tx(18),'Visible','off');
    set(S.an1,'Visible','on');
    set(S.pb(4),'Visible','on');
    set(S.pb(5),'Visible','on');
    set(S.pb(6),'Visible','on');
    set(S.pb(7),'Visible','on');
    set(S.pb(20),'Visible','on');
    set(S.pb(21),'Visible','on');
    set(S.pb(22),'Visible','on');
    set(S.ed(4),'Visible','on');
    set(S.ed(5),'Visible','on');
    set(S.tx(13),'Visible','on');
    set(S.tx(14),'Visible','on');
    set(S.tx(19),'Visible','on');
    set(S.tx(20),'Visible','on');
    set(S.cb(3),'Visible','on');
    set(S.cb(4),'Visible','on');
    set(S.cb(1),'Enable','on');
    set(S.cb(2),'Enable','on');
    set(S.cb(3),'Enable','on');
    set(S.pb(2),'Enable','on');
    set(S.pb(3),'Enable','on');
    set(S.pb(16),'Enable','on');
    set(S.pb(17),'Enable','on');
    set(S.pb(8),'Enable','on');
    set(S.pb(9),'Enable','on');
    set(S.pb(10),'Enable','on');
    set(S.pb(11),'Enable','on');
    set(S.pb(14),'Enable','on');
    set(S.pb(19),'Enable','on');
    set(S.pb(26),'Enable','on');
    set(S.sl(1),'Enable','on');
    set(S.pu(1),'Visible','on');
    set(S.pb(28),'Visible','on');
    set(S.pb(29),'Enable','on');
    set(S.pb(30),'Enable','on');
    set(S.pb(31),'Enable','on');
    set(S.cb(5),'Enable','on');
    A.playSpeed = 0.1;
    A.playState = true;
    A.copHold = 0;
    A.copCalced_local = 0;
    A.newForces = A.CoPmat(:,1);
    set(S.ed(4),'String','1');
    set(S.ed(4),'callback',{@ed_call_4,S});
    set(S.ed(5),'String',num2str(A.frames))
    set(S.ed(5),'callback',{@ed_call_5,S});
    set(S.pb(12),'callback',{@pb_call_12,S}); % Give functionality to the Export Masked CoP Sequence button
    set(S.cb(4),'callback',{@cb_call_4,S});
    set(S.pb(18),'callback',{@pb_call_18,S}); % Give functionality to the Export New CoP Data button
    set(S.pu(1),'callback',{@pu_call_1,S});
    set(S.pb(28),'callback',{@pb_call_28,S});
    A.polyCoor = {0,0};
    A.ply = {};
    A.polygonNum = 0;
    A.freehandNum = 0;
    A.rectangleNum = 0;
    A.ellipseNum = 0;
end
end

%% This button graphs the Total Force graph in a separate figure
function [] = pb_call_2(varargin) % Total Force Button
global A;
global F;
try
    figure(F.tf)
catch
    F.tf = figure('CloseRequestFcn',@tfClose_call); % Create a separate figure to draw the graph in
    A.totForce = A.CoPmat(:,1);
    F.tfPlot = plot(1:A.frames,A.totForce); % Graph the Total Force across all frames
    title('Total Force');
    xlabel('Frame');
    ylabel('Force [N]');
end
end

%% This button graphs the Peak Pressure graph in a separate figure
function [] = pb_call_3(varargin) % Peak Pressure Button
global D;
global A;
global F;
try
    figure(F.pp)
catch
    F.pp=figure('CloseRequestFcn',@ppClose_call); % Create a separate figure to draw the graph in
    A.maxPressures = zeros(1,A.frames);
    for i = 1:A.frames
        A.maxPressures(1,i)=max(max(D.data(:,:,i)));
    end
    F.ppPlot = plot(1:A.frames,A.maxPressures); % Graph the Peak Pressure across all frames
    title('Peak Pressure');
    xlabel('Frame');
    ylabel('Force [kPa]'); %%N = (0.25*(sum(kPa)))/10
end
end

%% These functions hide the corresponding graphs when the x button is hit to close them
function tfClose_call(varargin)
global F;
set(F.tf,'Visible','off')
end

function ppClose_call(varargin)
global F;
set(F.pp,'Visible','off')
end
%% Checking this checkbox calculates and applies or hides the weight text numbers to the current graph
% WARNING! THIS WILL TAKE TIME!!! THE TEXT FUNCTION, WHILE THE BEST OPTION FOR DISPLAYING THE NUMBERS,
% SLOWS DOWN ALL OTHER PROCESSES CONSIDERABLY!
function [] = cb_call_1(varargin) % Weight Text check box
global S;
global F;
global A;
global D;
set(0, 'currentfigure', F.fig2); % Make sure the heat map is the current figure
hold on;
[x, y] = meshgrid(1:64,1:95);
if A.curDisplay == 1 %1 for Normal Data, 0 for MPP, -1 for MVP. If the normal pressure data is displayed,
    if S.cb(1).Value == 1 % When the check box is checked, calculate and display the Weight Text numbers
        CurrentFrame = D.data(:,:,A.CurFrameNum);
        textStrings1 = num2str(CurrentFrame(:),'%3.0f');
        textStrings2 = strtrim(cellstr(textStrings1));
        F.hStrings = text(x(:),y(:),textStrings2(:),'HorizontalAlignment',...
            'center','FontSize',7,'Interpreter','none','HitTest','off');
        set(F.hStrings,'Visible','on');
    elseif S.cb(1).Value == 0 % Check box is unchecked
        set(F.hStrings,'Visible','off'); % Turn the visibility of the numbers off
    end
elseif A.curDisplay == 0 % If the MPP data is displayed,
    if S.cb(1).Value == 1 % When the check box is checked, calculate and display the Weight Text numbers
        CurrentFrame = A.MPPmat(:,:);
        textStrings1 = num2str(CurrentFrame(:),'%3.0f');
        textStrings2 = strtrim(cellstr(textStrings1));
        F.hStrings = text(x(:),y(:),textStrings2(:),'HorizontalAlignment',...
            'center','FontSize',7,'Interpreter','none','HitTest','off');
        set(F.hStrings,'Visible','on');
    elseif S.cb(1).Value == 0 % Check box is unchecked
        set(F.hStrings,'Visible','off'); % Turn the visibility of the numbers off
    end
elseif A.curDisplay == -1 % If the MVP data is displayed,
    if S.cb(1).Value == 1 % When the check box is checked, calculate and display the Weight Text numbers
        CurrentFrame = A.MVPmat(:,:);
        textStrings1 = num2str(CurrentFrame(:),'%3.0f');
        textStrings2 = strtrim(cellstr(textStrings1));
        F.hStrings = text(x(:),y(:),textStrings2(:),'HorizontalAlignment',...
            'center','FontSize',7,'Interpreter','none','HitTest','off');
        set(F.hStrings,'Visible','on');
    elseif S.cb(1).Value == 0 % Check box is unchecked
        set(F.hStrings,'Visible','off'); % Turn the visibility of the numbers off
    end
end
end

%% This check box is used to toggle on and off the visibility of the Center of Pressure line
function [] = cb_call_2(varargin) % Turn Off/On Center of Pressure Data
global S;
global A;
global F;
if A.curDisplay == 1 && S.cb(2).Value == 1
    advanceCoP(A.CoPmat,A.CurFrameNum,F.fig2,S.cb(2).Value); % Calculate and display Center of Pressure for current frame
elseif (A.curDisplay == 0 || A.curDisplay == -1) && S.cb(2).Value == 1
    Y_cp = A.CoPmat(:,3);
    X_cp = A.CoPmat(:,2);
    set(0, 'currentfigure', F.fig2);
    hold on;
    F.CoPline = plot(2*Y_cp,2*X_cp,'color','k','LineWidth',2); % Graph the Center of Pressure line on top of the heat map
else
    set(F.CoPline,'Visible','off') % Set the visibility to OFF
end
end

%% This function allows for frame navigation using the keyboard arrow keys
function [] = fh_kpfcn(varargin)
global F;
switch varargin{1,2}.Key
    case 'rightarrow'
        pb_call_10(varargin)
        figure(F.fig2);
    case 'leftarrow'
        pb_call_9(varargin)
        figure(F.fig2);
    otherwise
end
end

%% These functions make their corresponding windows visible
function [] = pb_call_29(varargin) % Navigation Tools
global S;
set(S.fhNav,'Visible','on');
end

function [] = pb_call_30(varargin) % Data Manipulation Tools
global S;
set(S.fhMan,'Visible','on');
end

function [] = pb_call_31(varargin) % Data Export Tools
global S;
set(S.fhExp,'Visible','on');
end

%% These functions hide their corresponding windows
function [] = fh_call_1(varargin)
global S;
set(S.fhNav,'Visible','off');
end

function [] = fh_call_2(varargin)
global S;
set(S.fhMan,'Visible','off');
end

function [] = fh_call_3(varargin)
global S;
set(S.fhExp,'Visible','off');
end
%% This button is used to jump to the first data frame
function [] = pb_call_8(varargin)
global S;
global A;
global F;
beep on;
if A.curDisplay == 1 % Only allow functionality of this button if the normal pressure data (Not MPP or MVP) is currently graphed
    A.CurFrameNum = 1;
    set(S.ed(1),'String',num2str(A.CurFrameNum));
    matGraph(A.CurFrameNum); % Change current graphed data to the desired frame
    set(S.cb(1),'Value',0); % Uncheck and delete Weight Text data for quick operation
    if isfield(F,'hStrings')
        delete(F.hStrings);
    end
    Y_cp = A.CoPmat(:,3);
    X_cp = A.CoPmat(:,2);
    set(0, 'currentfigure', F.fig2);
    hold on;
    F.CoPline = plot(2*Y_cp,2*X_cp,'color','k','LineWidth',2); % Graph the Center of Pressure line on top of the heat map
    advanceCoP(A.CoPmat,A.CurFrameNum,F.fig2,S.cb(2).Value); % Graph the current Center of Pressure with a red star
    if S.cb(4).Value == 1
        F.seqCoP = plot(A.CoPsequence(:,3)*2,A.CoPsequence(:,2)*2,'Color','m',...
            'LineWidth',1.5); % Map the newly calculated center of pressure path within the mask
        hold on
        F.selCoP = plot(A.CoPsequence(A.CurFrameNum,3)*2,A.CoPsequence(A.CurFrameNum,2)*2,'MarkerFaceColor','m',...
            'Marker','h','MarkerEdgeColor','k','MarkerSize',12); % Map the current center of pressure for the points within the selected mask
    end
    if get(S.cb(3),'Value') == 1
        maskList = cellfun(@(x) ~isa(x,'impoint'),A.ply);
        i = find(maskList);
        for j = i
            try
                delete(F.pgon{1,j});
            catch
            end
        end
        
        set(0, 'currentfigure', F.fig2);
        drawMask(A.ply,A.polyCoor);
    elseif get(S.cb(3),'Value') == 0
        
        maskList = cellfun(@(x) ~isa(x,'impoint'),A.ply);
        i = find(maskList);
        for j = i
            try
                delete(F.pgon{1,j});
            catch
            end
        end
    end
    if strcmp(get(F.tf,'Visible'),get(F.pp,'Visible'))&& strcmp(get(F.tf,'Visible'),'on')
        if get(S.cb(5),'Value') == 1
            figure(F.tf);
            F.tfPlot = plot(1:A.frames,A.totForce);
            hold on;
            try
                delete(F.curFrame_tf);
            catch
            end 
            F.curFrame_tf = plot(A.CurFrameNum,A.totForce(A.CurFrameNum),'MarkerFaceColor','m',...
                'Marker','p','MarkerEdgeColor','k','MarkerSize',12);
            title('Total Force');
            xlabel('Frame');
            ylabel('Force [N]');
            figure(F.pp);
            F.ppPlot = plot(1:A.frames,A.maxPressures);
            hold on;
            try
                delete(F.curFrame_pp);
            catch
            end
            F.curFrame_pp = plot(A.CurFrameNum,A.maxPressures(A.CurFrameNum),'MarkerFaceColor','m',...
                'Marker','p','MarkerEdgeColor','k','MarkerSize',12);
            title('Peak Pressure');
            xlabel('Frame');
            ylabel('Force [kPa]');
            figure(F.fig2);
        elseif get(S.cb(5),'Value') == 0
            figure(F.tf);
            try
                delete(F.curFrame_tf);
            catch
            end
            F.tfPlot = plot(1:A.frames,A.totForce);
            title('Total Force');
            xlabel('Frame');
            ylabel('Force [N]');
            figure(F.pp);
            try
                delete(F.curFrame_pp);
            catch
            end
            F.ppPlot = plot(1:A.frames,A.maxPressures);
            title('Peak Pressure');
            xlabel('Frame');
            ylabel('Force [kPa]');
            figure(F.fig2);
        end
    end
else
    beep;
    try
        figure(F.wrongGraph);
    catch
        F.wrongGraph = msgbox({'This button cannot be used with the current graphed data.'; % Pop up warning if used with another graph
            'Use the Navigate edit box to select a frame of non-MPP or non-MVP data to work with.'});
    end
end
figure(S.fhNav);
end

%% This button is used to decrement the desired frame by one and regraph the new data frame
function [] = pb_call_9(varargin)
global S;
global A;
global F;
beep on;
if (A.CurFrameNum - 1) >= 1
    if A.curDisplay == 1 % Only allow functionality of this button if the normal pressure data (Not MPP or MVP) is currently graphed
        A.CurFrameNum = A.CurFrameNum-1;
        set(S.ed(1),'String',num2str(A.CurFrameNum));
        matGraph(A.CurFrameNum); % Change current graphed data to the desired frame
        set(S.cb(1),'Value',0); % Uncheck and delete Weight Text data for quick operation
        if isfield(F,'hStrings')
            delete(F.hStrings);
        end
        Y_cp = A.CoPmat(:,3);
        X_cp = A.CoPmat(:,2);
        set(0, 'currentfigure', F.fig2);
        hold on;
        F.CoPline = plot(2*Y_cp,2*X_cp,'color','k','LineWidth',2); % Graph the Center of Pressure line on top of the heat map
        advanceCoP(A.CoPmat,A.CurFrameNum,F.fig2,S.cb(2).Value); % Graph the current Center of Pressure with a red star
        if S.cb(4).Value == 1
            F.seqCoP = plot(A.CoPsequence(:,3)*2,A.CoPsequence(:,2)*2,'Color','m',...
                'LineWidth',1.5); % Map the newly calculated center of pressure path within the mask
            hold on
            F.selCoP = plot(A.CoPsequence(A.CurFrameNum,3)*2,A.CoPsequence(A.CurFrameNum,2)*2,'MarkerFaceColor','m',...
                'Marker','h','MarkerEdgeColor','k','MarkerSize',12); % Map the current center of pressure for the points within the selected mask
        end
        if get(S.cb(3),'Value') == 1
            
            maskList = cellfun(@(x) ~isa(x,'impoint'),A.ply);
            i = find(maskList);
            for j = i
                try
                    delete(F.pgon{1,j});
                catch
                end
            end
            set(0, 'currentfigure', F.fig2);
            drawMask(A.ply,A.polyCoor);
        elseif get(S.cb(3),'Value') == 0
            
            maskList = cellfun(@(x) ~isa(x,'impoint'),A.ply);
            i = find(maskList);
            for j = i
                try
                    delete(F.pgon{1,j});
                catch
                end
            end
        end
        if strcmp(get(F.tf,'Visible'),get(F.pp,'Visible'))&& strcmp(get(F.tf,'Visible'),'on')
            if get(S.cb(5),'Value') == 1
                figure(F.tf);
                F.tfPlot = plot(1:A.frames,A.totForce);
                hold on;
                try
                    delete(F.curFrame_tf);
                catch
                end
                F.curFrame_tf = plot(A.CurFrameNum,A.totForce(A.CurFrameNum),'MarkerFaceColor','m',...
                    'Marker','p','MarkerEdgeColor','k','MarkerSize',12);
                title('Total Force');
                xlabel('Frame');
                ylabel('Force [N]');
                figure(F.pp);
                F.ppPlot = plot(1:A.frames,A.maxPressures);
                hold on;
                try
                    delete(F.curFrame_pp);
                catch
                end
                F.curFrame_pp = plot(A.CurFrameNum,A.maxPressures(A.CurFrameNum),'MarkerFaceColor','m',...
                    'Marker','p','MarkerEdgeColor','k','MarkerSize',12);
                title('Peak Pressure');
                xlabel('Frame');
                ylabel('Force [kPa]');
                figure(F.fig2);
            elseif get(S.cb(5),'Value') == 0
                figure(F.tf);
                try
                    delete(F.curFrame_tf);
                catch
                end
                F.tfPlot = plot(1:A.frames,A.totForce);
                title('Total Force');
                xlabel('Frame');
                ylabel('Force [N]');
                figure(F.pp);
                try
                    delete(F.curFrame_pp);
                catch
                end
                F.ppPlot = plot(1:A.frames,A.maxPressures);
                title('Peak Pressure');
                xlabel('Frame');
                ylabel('Force [kPa]');
                figure(F.fig2);
            end
        end
    else
        beep;
        msgbox({'This button cannot be used with the current graphed data.'; %Pop up warning if used with another graph
            'Use the Navigate edit box to select a frame of non-MPP or non-MVP data to work with.'})
    end
else
    beep;
    try
        figure(F.warn);
    catch
        F.warn = msgbox('Desired frame is outside the range. Search in the opposite direction.','Error','error'); % Display when user attempts to move outside frame range
        waitfor(F.warn);
    end
end
figure(S.fhNav);
end

%% This button is used to increment the desired frame by one and regraph the new data frame
function [] = pb_call_10(varargin)
global S;
global A;
global F;
beep on;
if (A.CurFrameNum + 1) <= A.frames
    if A.curDisplay == 1 % Only allow functionality of this button if the normal pressure data (Not MPP or MVP) is currently graphed
        A.CurFrameNum = A.CurFrameNum+1;
        set(S.ed(1),'String',num2str(A.CurFrameNum));
        matGraph(A.CurFrameNum); % Change current graphed data to the desired frame
        set(S.cb(1),'Value',0); % Uncheck and delete Weight Text data for quick operation
        if isfield(F,'hStrings')
            delete(F.hStrings);
        end
        Y_cp = A.CoPmat(:,3);
        X_cp = A.CoPmat(:,2);
        set(0, 'currentfigure', F.fig2);
        hold on;
        F.CoPline = plot(2*Y_cp,2*X_cp,'color','k','LineWidth',2); % Graph the Center of Pressure line on top of the heat map
        advanceCoP(A.CoPmat,A.CurFrameNum,F.fig2,S.cb(2).Value); % Graph the current Center of Pressure with a red star
        if S.cb(4).Value == 1
            F.seqCoP = plot(A.CoPsequence(:,3)*2,A.CoPsequence(:,2)*2,'Color','m',...
                'LineWidth',1.5); % Map the newly calculated center of pressure path within the mask
            hold on
            F.selCoP = plot(A.CoPsequence(A.CurFrameNum,3)*2,A.CoPsequence(A.CurFrameNum,2)*2,'MarkerFaceColor','m',...
                'Marker','h','MarkerEdgeColor','k','MarkerSize',12); % Map the current center of pressure for the points within the selected mask
        end
        if get(S.cb(3),'Value') == 1
            
            maskList = cellfun(@(x) ~isa(x,'impoint'),A.ply);
            i = find(maskList);
            for j = i
                try
                    delete(F.pgon{1,j});
                catch
                end
            end
            
            set(0, 'currentfigure', F.fig2);
            drawMask(A.ply,A.polyCoor);
            
        elseif get(S.cb(3),'Value') == 0
            
            maskList = cellfun(@(x) ~isa(x,'impoint'),A.ply);
            i = find(maskList);
            for j = i
                try
                    delete(F.pgon{1,j});
                catch
                end
            end
        end
        if strcmp(get(F.tf,'Visible'),get(F.pp,'Visible'))&& strcmp(get(F.tf,'Visible'),'on')
            if get(S.cb(5),'Value') == 1
                figure(F.tf);
                F.tfPlot = plot(1:A.frames,A.totForce);
                hold on;
                try
                    delete(F.curFrame_tf);
                catch
                end
                F.curFrame_tf = plot(A.CurFrameNum,A.totForce(A.CurFrameNum),'MarkerFaceColor','m',...
                    'Marker','p','MarkerEdgeColor','k','MarkerSize',12);
                title('Total Force');
                xlabel('Frame');
                ylabel('Force [N]');
                figure(F.pp);
                F.ppPlot = plot(1:A.frames,A.maxPressures);
                hold on;
                try
                    delete(F.curFrame_pp);
                catch
                end
                F.curFrame_pp = plot(A.CurFrameNum,A.maxPressures(A.CurFrameNum),'MarkerFaceColor','m',...
                    'Marker','p','MarkerEdgeColor','k','MarkerSize',12);
                title('Peak Pressure');
                xlabel('Frame');
                ylabel('Force [kPa]');
                figure(F.fig2);
            elseif get(S.cb(5),'Value') == 0
                figure(F.tf);
                try
                    delete(F.curFrame_tf);
                catch
                end
                F.tfPlot = plot(1:A.frames,A.totForce);
                title('Total Force');
                xlabel('Frame');
                ylabel('Force [N]');
                figure(F.pp);
                try
                    delete(F.curFrame_pp);
                catch
                end
                F.ppPlot = plot(1:A.frames,A.maxPressures);
                title('Peak Pressure');
                xlabel('Frame');
                ylabel('Force [kPa]');
                figure(F.fig2);
            end
        end
    else
        beep;
        msgbox({'This button cannot be used with the current graphed data.';  % Pop up warning if used with another graph
            'Use the Navigate edit box to select a frame of non-MPP or non-MVP data to work with.'})
    end
else
    beep;
    try
        figure(F.warn);
    catch
        F.warn = msgbox('Desired frame is outside the range. Search in the opposite direction.','Error','error'); % Display when user attempts to move outside frame range
        waitfor(F.warn);
    end
end
figure(S.fhNav);
end

%% This button is used to jump to the last data frame
function [] = pb_call_11(varargin)
global S;
global A;
global F;
beep on;
if A.curDisplay == 1 % Only allow functionality of this button if the normal pressure data (Not MPP or MVP) is currently graphed
    A.CurFrameNum = A.frames;
    set(S.ed(1),'String',num2str(A.CurFrameNum));
    matGraph(A.CurFrameNum); % Change current graphed data to the desired frame
    set(S.cb(1),'Value',0); % Uncheck and delete Weight Text data for quick operation
    if isfield(F,'hStrings')
        delete(F.hStrings);
    end
    Y_cp = A.CoPmat(:,3);
    X_cp = A.CoPmat(:,2);
    set(0, 'currentfigure', F.fig2);
    hold on;
    F.CoPline = plot(2*Y_cp,2*X_cp,'color','k','LineWidth',2); % Graph the Center of Pressure line on top of the heat map
    advanceCoP(A.CoPmat,A.CurFrameNum,F.fig2,S.cb(2).Value); % Graph the current Center of Pressure with a red star
    if S.cb(4).Value == 1
        F.seqCoP = plot(A.CoPsequence(:,3)*2,A.CoPsequence(:,2)*2,'Color','m',...
            'LineWidth',1.5); % Map the newly calculated center of pressure path within the mask
        hold on
        F.selCoP = plot(A.CoPsequence(A.CurFrameNum,3)*2,A.CoPsequence(A.CurFrameNum,2)*2,'MarkerFaceColor','m',...
            'Marker','h','MarkerEdgeColor','k','MarkerSize',12); % Map the current center of pressure for the points within the selected mask
    end
    if get(S.cb(3),'Value') == 1
        try
            maskList = cellfun(@(x) ~isa(x,'impoint'),A.ply);
            i = find(maskList);
            for j = i
                delete(F.pgon{1,j});
            end
        catch
        end
        set(0, 'currentfigure', F.fig2);
        drawMask(A.ply,A.polyCoor);
    elseif get(S.cb(3),'Value') == 0
        
        maskList = cellfun(@(x) ~isa(x,'impoint'),A.ply);
        i = find(maskList);
        for j = i
            try
                delete(F.pgon{1,j});
            catch
            end
        end
    end
    if strcmp(get(F.tf,'Visible'),get(F.pp,'Visible'))&& strcmp(get(F.tf,'Visible'),'on')
        if get(S.cb(5),'Value') == 1
            figure(F.tf);
            F.tfPlot = plot(1:A.frames,A.totForce);
            hold on;
            try
                delete(F.curFrame_tf);
            catch
            end
            F.curFrame_tf = plot(A.CurFrameNum,A.totForce(A.CurFrameNum),'MarkerFaceColor','m',...
                'Marker','p','MarkerEdgeColor','k','MarkerSize',12);
            title('Total Force');
            xlabel('Frame');
            ylabel('Force [N]');
            figure(F.pp);
            F.ppPlot = plot(1:A.frames,A.maxPressures);
            hold on;
            try
                delete(F.curFrame_pp);
            catch
            end
            F.curFrame_pp = plot(A.CurFrameNum,A.maxPressures(A.CurFrameNum),'MarkerFaceColor','m',...
                'Marker','p','MarkerEdgeColor','k','MarkerSize',12);
            title('Peak Pressure');
            xlabel('Frame');
            ylabel('Force [kPa]');
            figure(F.fig2);
        elseif get(S.cb(5),'Value') == 0
            figure(F.tf);
            try
                delete(F.curFrame_tf);
            catch
            end
            F.tfPlot = plot(1:A.frames,A.totForce);
            title('Total Force');
            xlabel('Frame');
            ylabel('Force [N]');
            figure(F.pp);
            try
                delete(F.curFrame_pp);
            catch
            end
            F.ppPlot = plot(1:A.frames,A.maxPressures);
            title('Peak Pressure');
            xlabel('Frame');
            ylabel('Force [kPa]');
            figure(F.fig2);
        end
    end
else
    beep;
    try
        figure(F.wrongGraph);
    catch
        F.wrongGraph = msgbox({'This button cannot be used with the current graphed data.'; % Pop up warning if used with another graph
            'Use the Navigate edit box to select a frame of non-MPP or non-MVP data to work with.'});
    end
end
figure(S.fhNav);
end

%% This edit box is used to jump to the desired input data frame
function [] = ed_call_1(varargin)
global S;
global A;
global F;
desiredFrame = str2num(char(get(S.ed(1),'String'))); %#ok<ST2NM>
beep on;
if isscalar(desiredFrame)
    if (1 <= desiredFrame) && (desiredFrame<= A.frames)
        matGraph(desiredFrame); % Change current graphed data to the desired frame
        A.curDisplay = 1; %1 for Normal Data, 0 for MPP, -1 for MVP
        set(S.cb(1),'Value',0); % Uncheck and delete Weight Text data for quick operation
        if isfield(F,'hStrings')
            delete(F.hStrings);
        end
        Y_cp = A.CoPmat(:,3);
        X_cp = A.CoPmat(:,2);
        set(0, 'currentfigure', F.fig2);
        hold on;
        F.CoPline = plot(2*Y_cp,2*X_cp,'color','k','LineWidth',2); % Graph the Center of Pressure line on top of the heat map
        advanceCoP(A.CoPmat,A.CurFrameNum,F.fig2,S.cb(2).Value); % Graph the current Center of Pressure with a red star
        if S.cb(4).Value == 1
            F.seqCoP = plot(A.CoPsequence(:,3)*2,A.CoPsequence(:,2)*2,'Color','m',...
                'LineWidth',1.5); % Map the newly calculated center of pressure path within the mask
            hold on
            F.selCoP = plot(A.CoPsequence(A.CurFrameNum,3)*2,A.CoPsequence(A.CurFrameNum,2)*2,'MarkerFaceColor','m',...
                'Marker','h','MarkerEdgeColor','k','MarkerSize',12); % Map the current center of pressure for the points within the selected mask
        end
        if get(S.cb(3),'Value') == 1
            maskList = cellfun(@(x) ~isa(x,'impoint'),A.ply);
            i = find(maskList);
            for j = i
                try
                    delete(F.pgon{1,j});
                catch
                end
            end
            
            set(0, 'currentfigure', F.fig2);
            drawMask(A.ply,A.polyCoor);
        elseif get(S.cb(3),'Value') == 0
            
            maskList = cellfun(@(x) ~isa(x,'impoint'),A.ply);
            i = find(maskList);
            for j = i
                try
                    delete(F.pgon{1,j});
                catch
                end
            end
        end
        if strcmp(get(F.tf,'Visible'),get(F.pp,'Visible')) && strcmp(get(F.tf,'Visible'),'on')
            if get(S.cb(5),'Value') == 1
                figure(F.tf);
                F.tfPlot = plot(1:A.frames,A.totForce);
                hold on;
                try
                    delete(F.curFrame_tf);
                catch
                end
                F.curFrame_tf = plot(A.CurFrameNum,A.totForce(A.CurFrameNum),'MarkerFaceColor','m',...
                    'Marker','p','MarkerEdgeColor','k','MarkerSize',12);
                title('Total Force');
                xlabel('Frame');
                ylabel('Force [N]');
                figure(F.pp);
                F.ppPlot = plot(1:A.frames,A.maxPressures);
                hold on;
                try
                    delete(F.curFrame_pp);
                catch
                end
                F.curFrame_pp = plot(A.CurFrameNum,A.maxPressures(A.CurFrameNum),'MarkerFaceColor','m',...
                    'Marker','p','MarkerEdgeColor','k','MarkerSize',12);
                title('Peak Pressure');
                xlabel('Frame');
                ylabel('Force [kPa]');
                figure(F.fig2);
            elseif get(S.cb(5),'Value') == 0
                figure(F.tf);
                try
                    delete(F.curFrame_tf);
                catch
                end
                F.tfPlot = plot(1:A.frames,A.totForce);
                title('Total Force');
                xlabel('Frame');
                ylabel('Force [N]');
                figure(F.pp);
                try
                    delete(F.curFrame_pp);
                catch
                end
                F.ppPlot = plot(1:A.frames,A.maxPressures);
                title('Peak Pressure');
                xlabel('Frame');
                ylabel('Force [kPa]');
                figure(F.fig2);
            end
        end
    else
        beep;  % Display when user attempts to move outside frame range
        F.bounds = msgbox(sprintf('Desired frame is outside the range.\nMake sure your search is between 1 and %i.',A.frames),'Error','error');
        A.CurFrameNum = 1;
        set(S.ed(1),'String',A.CurFrameNum)
    end
end
set(S.pb(11),'Visible','on')
set(S.pb(10),'Visible','on')
set(S.pb(9),'Visible','on')
set(S.pb(8),'Visible','on')
set(S.ed(1),'Position',[170 150 50 30])
set(S.pb(25),'Visible','off')
figure(S.fhNav);
end

%% This button plays the frame sequence backward from the current frame to the end frame
function [] = pb_call_14(varargin)
global S;
global A;
global F;
pause('on');
set(S.cb(1),'Value',0); % Uncheck and delete Weight Text data for quick operation
if isfield(F,'hStrings')
    delete(F.hStrings);
end
for x = 1:str2num(char(get(S.ed(1),'String')))-1 %#ok<ST2NM>
    if A.playState == false
        break
    end
    pause(A.playSpeed)
    pb_call_9
end
A.playState = true;
end

%% This button stops the play button sequence
function [] = pb_call_26(varargin)
global A;
A.playState = false;
end

%% This button plays the frame sequence forward from the current frame to the end frame
function [] = pb_call_19(varargin)
global S;
global A;
global F;
pause('on');
set(S.cb(1),'Value',0); % Uncheck and delete Weight Text data for quick operation
if isfield(F,'hStrings')
    delete(F.hStrings);
end
for y = str2num(char(get(S.ed(1),'String'))):A.frames-1 %#ok<ST2NM>
    if A.playState == false
        break
    end
    pause(A.playSpeed)
    pb_call_10
end
A.playState = true;
end

%% This slider increases and decreases the playback speed
function [] = sl_call_1(varargin)
global S;
global A;
A.playSpeed = get(S.sl(1),'Value');
set(S.ed(6),'String',num2str(get(S.sl(1),'Value')))
end

%% This edit box edits the playback speed manually and manipulates the slider
function [] = ed_call_6(varargin)
global S;
global A;
val = str2num(char(get(S.ed(6),'String'))); %#ok<ST2NM>
if val > 1
    set(S.ed(6),'String','1');
elseif val < 0.1
    set(S.ed(6),'String','0.1');
end
A.playSpeed = str2num(char(get(S.ed(6),'String'))); %#ok<ST2NM>
set(S.sl(1),'Value',A.playSpeed);
end

%% This button graphs the MPP data
function [] = pb_call_16(varargin)
global S;
global D;
global A;
global F;
set(0, 'currentfigure', F.fig2); % Make sure the heat map is the current figure
hold on;
F.h_MPP = imagesc(A.MPPmat(:,:)); % Graphs the MPP data as a heat map on the figure
A.curDisplay = 0; %1 for Normal Data, 0 for MPP, -1 for MVP
colormap(jet); % Set the heat map color scheme to 'Jet'
colorbar; % Display the color bar on the right side of the map
highestNum = max(max(max(D.data))); % Use the highest pressure of all the frames to
caxis([0,highestNum]); % determine the highest number displayed by the color bar and make sure
set(S.cb(1),'Value',0); % the color scheme is consistent across all frames, then uncheck the Weight Text checkbox for speed purposes
if isfield(F,'hStrings')
    delete(F.hStrings);
end
Y_cp = A.CoPmat(:,3);
X_cp = A.CoPmat(:,2);
set(0, 'currentfigure', F.fig2);
hold on;
if S.cb(2).Value == 1
    F.CoPline = plot(2*Y_cp,2*X_cp,'color','k','LineWidth',2); % Graph the Center of Pressure line on top of the heat map
end
set(S.pb(11),'Visible','off')
set(S.pb(10),'Visible','off')
set(S.pb(9),'Visible','off')
set(S.pb(8),'Visible','off')
set(S.ed(1),'Position',[170 110 50 30])
set(S.pb(25),'Visible','on')
set(S.pb(25),'callback',{@pb_call_25,S});
set(S.pb(14),'Visible','off');
set(S.pb(19),'Visible','off');
set(S.pb(26),'Visible','off');
end

%% This button returns the graph from displaying MPP or MVP to Single Frame Mode
function [] = pb_call_25(varargin) %Return to Single Frame Button
global A;
global S;
global F;
set(S.pb(11),'Visible','on')
set(S.pb(10),'Visible','on')
set(S.pb(9),'Visible','on')
set(S.pb(8),'Visible','on')
set(S.ed(1),'Position',[170 150 50 30])
set(S.pb(25),'Visible','off')
matGraph(str2num(char(get(S.ed(1),'String')))); %#ok<ST2NM>
A.curDisplay = 1; %1 for Normal Data, 0 for MPP, -1 for MVP
set(S.cb(1),'Value',0); % Uncheck and delete Weight Text data for quick operation
if isfield(F,'hStrings')
    delete(F.hStrings);
end
Y_cp = A.CoPmat(:,3);
X_cp = A.CoPmat(:,2);
set(0, 'currentfigure', F.fig2);
hold on;
F.CoPline = plot(2*Y_cp,2*X_cp,'color','k','LineWidth',2); % Graph the Center of Pressure line on top of the heat map
advanceCoP(A.CoPmat,A.CurFrameNum,F.fig2,S.cb(2).Value); % Graph the current Center of Pressure with a red star
if A.copHold == 1 && A.copCalced_local == 1
    delete(F.seqCoP)
    delete(F.selCoP)
    F.seqCoP = plot(A.CoPsequence(:,3)*2,A.CoPsequence(:,2)*2,'Color','m',...
        'LineWidth',1.5); % Map the newly calculated center of pressure path within the mask
    hold on
    F.selCoP = plot(A.CoPcoord(1,1),A.CoPcoord(1,2),'MarkerFaceColor','m',...
        'Marker','h','MarkerEdgeColor','k','MarkerSize',12); % Map the current center of pressure for the points within the selected mask
elseif A.copHold == 0 && A.copCalced_local == 1
    delete(F.seqCoP)
    delete(F.selCoP)
end
if S.cb(4).Value == 1
    F.seqCoP = plot(A.CoPsequence(:,3)*2,A.CoPsequence(:,2)*2,'Color','m',...
        'LineWidth',1.5); % Map the newly calculated center of pressure path within the mask
    hold on
    F.selCoP = plot(A.CoPcoord(1,1),A.CoPcoord(1,2),'MarkerFaceColor','m',...
        'Marker','h','MarkerEdgeColor','k','MarkerSize',12); % Map the current center of pressure for the points within the selected mask
end
if get(S.cb(3),'Value') == 1
    maskList = cellfun(@(x) ~isa(x,'impoint'),A.ply);
    i = find(maskList);
    for j = i
        try
            delete(F.pgon{1,j});
        catch
        end
    end
    set(0, 'currentfigure', F.fig2);
    drawMask(A.ply,A.polyCoor);
elseif get(S.cb(3),'Value') == 0
    maskList = cellfun(@(x) ~isa(x,'impoint'),A.ply);
    i = find(maskList);
    for j = i
        try
            delete(F.pgon{1,j});
        catch
        end
    end
end
set(S.pb(14),'Visible','on');
set(S.pb(19),'Visible','on');
set(S.pb(26),'Visible','on');
end

%% This tool is used to circle desired data points to create a mask for a variety of uses
function [] = pb_call_4(varargin) %Draw Area Tool
global F;
global R;
global A;
global D;
global S;
set(0, 'currentfigure', F.fig2); % Make sure the heat map is the current figure
A.drawType = toolEval;

switch A.drawType
    case 1 % Straight Line
        Preply = impoly; %#ok<IMPOLY>
        shapeName = 'Polygon';
        A.polygonNum = A.polygonNum + 1;
    case 2 % Free Hand
        Preply = imfreehand; %#ok<IMFREEH>
        shapeName = 'Free_Hand';
        A.freehandNum = A.freehandNum + 1;
    case 3 % Rectangle
        Preply = imrect; %#ok<IMRECT>
        shapeName = 'Rectangle';
        A.rectangleNum = A.rectangleNum + 1;
    case 4 % Ellipse
        Preply = imellipse; %#ok<IMELLPS>
        shapeName = 'Ellipse';
        A.ellipseNum = A.ellipseNum + 1;
    case 5 % Point Marker
        Preply = impoint; %#ok<IMPNT>
end
try
    pos = getPosition(Preply);
    if ~isa(Preply,'impoint')
        preString = get(S.pu,'String');
        switch A.drawType
            case 1
                shapeCount = A.polygonNum;
            case 2
                shapeCount = A.freehandNum;
            case 3
                shapeCount = A.rectangleNum;
            case 4
                shapeCount = A.ellipseNum;
        end
        newObject = strcat([shapeName,' ',num2str(shapeCount)]);
        set(S.pu,'String',{preString{:,1},newObject});
    end
catch
end
sz = size(D.data);
if R.cb(1).Value == 1
    switch A.drawType
        case 1 % Straight Line
            for i = 1:size(pos,1)
                if pos(i,2) > sz(1,1)
                    pos(i,2) = sz(1,1);
                elseif pos(i,2) < 0
                    pos(i,2) = 0;
                end
                if pos(i,1) > sz(1,2)
                    pos(i,1) = sz(1,2);
                elseif pos(i,1) < 0
                    pos(i,1) = 0;
                end
            end
            setConstrainedPosition(Preply,pos);
        case 2 % Free Hand
            delete(Preply)
            posX = pos(:,1);
            posY = pos(:,2);
            posX(posX(:,1)>sz(1,2)) = sz(1,2);
            posX(posX(:,1)<0) = 0;
            posY(posY(:,1)>sz(1,1)) = sz(1,1);
            posY(posY(:,1)<0) = 0;
            pos = [posX,posY];
            Preply = imfreehand(F.h.Parent,pos); %#ok<IMFREEH>
        case 3 % Rectangle
            if ((pos(1,1) + pos(1,3)) > sz(1,2)) && ((pos(1,2) + pos(1,4)) > sz(1,1))
                setConstrainedPosition(Preply,[pos(1,1),pos(1,2),sz(1,2)-pos(1,1),sz(1,1)-pos(1,2)]);
            elseif ((pos(1,1) + pos(1,3)) > sz(1,2)) && (pos(1,2) < 0)
                setConstrainedPosition(Preply,[pos(1,1),0,sz(1,2)-pos(1,1),pos(1,4)+pos(1,2)]);
            elseif (pos(1,1) < 0) && (pos(1,2) < 0)
                setConstrainedPosition(Preply,[0,0,pos(1,3)+pos(1,1),pos(1,4)+pos(1,2)]);
            elseif (pos(1,1) < 0) && ((pos(1,2) + pos(1,4)) > sz(1,1))
                setConstrainedPosition(Preply,[0,pos(1,2),pos(1,3)+pos(1,1),sz(1,1)-pos(1,2)]);
            elseif (pos(1,2) + pos(1,4)) > sz(1,1)
                setConstrainedPosition(Preply,[pos(1,1),pos(1,2),pos(1,3),sz(1,1)-pos(1,2)]);
            elseif (pos(1,1) + pos(1,3)) > sz(1,2)
                setConstrainedPosition(Preply,[pos(1,1),pos(1,2),sz(1,2)-pos(1,1),pos(1,4)]);
            elseif pos(1,1) < 0
                setConstrainedPosition(Preply,[0,pos(1,2),pos(1,3)+pos(1,1),pos(1,4)]);
            elseif pos(1,2) < 0
                setConstrainedPosition(Preply,[pos(1,1),0,pos(1,3),pos(1,4)+pos(1,2)]);
            end
        case 4 % Ellipse
            if ((pos(1,1) + pos(1,3)) > sz(1,2)) && ((pos(1,2) + pos(1,4)) > sz(1,1))
                setConstrainedPosition(Preply,[pos(1,1),pos(1,2),sz(1,2)-pos(1,1),sz(1,1)-pos(1,2)]);
            elseif ((pos(1,1) + pos(1,3)) > sz(1,2)) && (pos(1,2) < 0)
                setConstrainedPosition(Preply,[pos(1,1),0,sz(1,2)-pos(1,1),pos(1,4)+pos(1,2)]);
            elseif (pos(1,1) < 0) && (pos(1,2) < 0)
                setConstrainedPosition(Preply,[0,0,pos(1,3)+pos(1,1),pos(1,4)+pos(1,2)]);
            elseif (pos(1,1) < 0) && ((pos(1,2) + pos(1,4)) > sz(1,1))
                setConstrainedPosition(Preply,[0,pos(1,2),pos(1,3)+pos(1,1),sz(1,1)-pos(1,2)]);
            elseif (pos(1,2) + pos(1,4)) > sz(1,1)
                setConstrainedPosition(Preply,[pos(1,1),pos(1,2),pos(1,3),sz(1,1)-pos(1,2)]);
            elseif (pos(1,1) + pos(1,3)) > sz(1,2)
                setConstrainedPosition(Preply,[pos(1,1),pos(1,2),sz(1,2)-pos(1,1),pos(1,4)]);
            elseif pos(1,1) < 0
                setConstrainedPosition(Preply,[0,pos(1,2),pos(1,3)+pos(1,1),pos(1,4)]);
            elseif pos(1,2) < 0
                setConstrainedPosition(Preply,[pos(1,1),0,pos(1,3),pos(1,4)+pos(1,2)]);
            end
        case 5 % Point Marker
            if (pos(1,1) > sz(1,2)) && (pos(1,2) > sz(1,1))
                setConstrainedPosition(Preply,[sz(1,2),sz(1,1)]);
            elseif (pos(1,1) > sz(1,2)) && (pos(1,2) < 0)
                setConstrainedPosition(Preply,[sz(1,2),0]);
            elseif (pos(1,1) < 0) && (pos(1,2) > sz(1,1))
                setConstrainedPosition(Preply,[0,sz(1,1)]);
            elseif (pos(1,1) < 0) && (pos(1,2) < 0)
                setConstrainedPosition(Preply,[0,0]);
            elseif pos(1,2) > sz(1,1)
                setConstrainedPosition(Preply,[pos(1,1),sz(1,1)]);
            elseif pos(1,1) > sz(1,2)
                setConstrainedPosition(Preply,[sz(1,2),pos(1,2)]);
            elseif pos(1,2) < 0
                setConstrainedPosition(Preply,[pos(1,1),0]);
            elseif pos(1,1) < 0
                setConstrainedPosition(Preply,[0,pos(1,2)]);
            end
    end
    pos = getPosition(Preply);
end
ptPresent = 0;
try
    for i = 1:length(A.ply)
        if isa(A.ply{1,i},'impoint')
            if isvalid(A.ply{1,i})
                ptPresent = 1;
                break;
            elseif isempty(A.ply{1,i})
                ptPresent = 2;
                break;
            end
        end
    end
    if isempty(A.ply)
        A.ply{1,1} = Preply;
        if A.drawType == 5
            set(A.ply{end}(end,1),'Visible','off');
        end
    elseif ptPresent == 2
        A.ply{1,i} = Preply;
        set(A.ply{1,i},'Visible','off');
    elseif isa(A.ply{end},'impoint') && A.drawType == 5 && all(isvalid(A.ply{end}))
        A.ply{1,end} = [A.ply{end}; Preply];
        set(A.ply{end}(end,1),'Visible','off');
    elseif ~isa(A.ply{end},'impoint') && ptPresent == 1
        A.ply{1,i} = [A.ply{i}; Preply];
        set(A.ply{end}(end,1),'Visible','off');
    else
        A.ply = [A.ply , {Preply}];
        if A.drawType == 5
            set(A.ply{end}(end,1),'Visible','off');
        end
    end
    if A.drawType == 5
        maskList = cellfun(@(x) isa(x,'impoint'),A.ply);
        i = find(maskList);
        sz = size(A.polyCoor);
        if ptPresent == 2
            A.polyCoor{1,(i*2-1)} = pos(1,1);
            A.polyCoor{1,(i*2)} = pos(1,2);
        elseif sz(1,2) < i*2 || ((A.polyCoor{1,(i*2-1)}(1,1) == 0) && (A.polyCoor{1,(i*2)}(1,1) == 0))
            A.polyCoor{1,(i*2-1)} = pos(1,1);
            A.polyCoor{1,(i*2)} = pos(1,2);
        else
            A.polyCoor{1,(i*2-1)} = [A.polyCoor{1,(i*2-1)};pos(1,1)];
            A.polyCoor{1,(i*2)} = [A.polyCoor{1,(i*2)};pos(1,2)];
            try
                delete(F.refPts)
            catch
            end
        end
        hold on;
        if isfield(A,'color')
            F.refPts = scatter(A.polyCoor{1,(i*2-1)},A.polyCoor{1,(i*2)},'MarkerEdgeColor',A.color);
        else
            F.refPts = scatter(A.polyCoor{1,(i*2-1)},A.polyCoor{1,(i*2)});
        end
        pb_call_4;
    end
    % Hit escape to finish placing points
catch
end
set(S.cb(3),'callback',{@cb_call_3,S});
set(S.pb(6),'callback',{@pb_call_6,S});
set(S.pb(21),'callback',{@pb_call_21,S});
set(S.pb(22),'callback',{@pb_call_22,S});
end

%% Mask and Edit
function [] = pb_call_21(varargin)
global A;
maskList = cellfun(@(x) ~isa(x,'impoint'),A.ply);
i = find(maskList);
eval_draw(A.ply,i);
for j = i
    if isvalid(A.ply{1,j})
        set(A.ply{1,j},'Visible','off')
    end
end
end

function [] = pb_call_22(varargin)
global A;
maskList = cellfun(@(x) ~isa(x,'impoint'),A.ply);
for i = 1:length(maskList)
    if maskList(1,i) == 1
        if isvalid(A.ply{1,i})
            set(A.ply{1,i},'Visible','on')
            old_warning_state = warning('off', 'MATLAB:structOnObject');
            ply_struct = struct(A.ply{1,i});
            warning(old_warning_state);
            uistack(ply_struct.h_group, 'top');
        end
    end
end
end

%% This button creates a new window where draw options for the Draw Area Tool may be changed
function [] = pb_call_20(varargin)
global R;
set(R.fh,'Visible','on');
R.oldSelect = R.bg.SelectedObject.String;
end

function [] = DT_call_1(varargin)
global R;
set(R.fh,'Visible','off');
end

function [] = DT_call_2(varargin)
global R;
toolType = R.oldSelect;
switch toolType
    case 'Straight Line'
        drawType = 1;
    case 'Free Hand'
        drawType = 2;
    case 'Rectangle'
        drawType = 3;
    case 'Ellipse'
        drawType = 4;
    case 'Point Marker'
        drawType = 5;
end
R.rb(drawType).Value = true;
set(R.fh,'Visible','off');
end

function [] = DT_call_3(varargin)
global F;
global A;
try
    delete(F.refPts);
    maskList = cellfun(@(x) isa(x,'impoint'),A.ply);
    i = find(maskList);
    for j = 1:length(A.ply{1,i})
        A.polyCoor{1,(i*2-1)} = [];
        A.polyCoor{1,(i*2)} = [];
        A.ply{1,i}(:,1) = [];
    end
catch
end
end

function [] = DT_call_4(varargin)
global A;
A.color = uisetcolor;
end

function [] = DT_call_5(varargin)
global A;
global F;
global R;
global S;
ptPresent = 0;
if  R.cb(2).Value == 1
    for i = 1:length(A.ply)
        if isa(A.ply{i},'impoint')
            if isvalid(A.ply{1,i})
                ptPresent = 1;
                break;
            end
        end
    end
    
    if ptPresent == 1
        for j=1:length(A.ply{1,i})
            if isvalid(A.ply{1,i}(j,1))
                set(A.ply{1,i}(j,1),'Visible','on');
                delete(F.refPts);
            end
        end
    end
elseif R.cb(2).Value == 0
    for i = 1:length(A.ply)
        if isa(A.ply{i},'impoint')
            if isvalid(A.ply{1,i})
                ptPresent = 1;
                break;
            end
        end
    end
    set(0, 'currentfigure', F.fig2);
    if ptPresent == 1
        for k = 1:length(A.ply{1,i})
            pos = getPosition(A.ply{1,i}(k,1));
            A.polyCoor{1,(i*2-1)}(k,1) = pos(1,1);
            A.polyCoor{1,(i*2)}(k,1) = pos(1,2);
        end
        for j = 1:length(A.ply{1,i})
            set(A.ply{1,i}(j,1),'Visible','off');
        end
        if isfield(A,'color')
            F.refPts = scatter(A.polyCoor{1,(i*2-1)},A.polyCoor{1,(i*2)},'MarkerEdgeColor',A.color);
        else
            F.refPts = scatter(A.polyCoor{1,(i*2-1)},A.polyCoor{1,(i*2)});
        end
    end
    if S.cb(3).Value == 0
        set(F.refPts,'Visible','off')
    end
end
end

%% These edit boxes are restricted to their proper ranges
function [] = ed_call_4(varargin)
global S;
a = get(S.ed(4),'String');
a = str2num(char(a)); %#ok<ST2NM>
if a < 1
    set(S.ed(4),'String','1');
end
end

function [] = ed_call_5(varargin)
global S;
global A;
b = get(S.ed(5),'String');
b = str2num(char(b)); %#ok<ST2NM>
if b > A.frames
    set(S.ed(5),'String',num2str(A.frames));
end
end
%% This checkbox highlights the previously masked area on the graph for reference purposes
function [] = cb_call_3(varargin)
global A;
global S;
global F;
if get(S.cb(3),'Value') == 1
    set(0, 'currentfigure', F.fig2);
    try
        set(F.refPts,'Visible','on');
    catch
    end
    ptPresent = 0;
    for i = 1:length(A.ply)
        if isa(A.ply{i},'impoint')
            if isvalid(A.ply{1,i})
                ptPresent = 1;
                break;
            end
        end
    end
    if ptPresent == 1
        for k = 1:length(A.ply{1,i})
            pos = getPosition(A.ply{1,i}(k,1));
            A.polyCoor{1,(i*2-1)}(k,1) = pos(1,1);
            A.polyCoor{1,(i*2)}(k,1) = pos(1,2);
        end
    end
    drawMask(A.ply,A.polyCoor);
elseif get(S.cb(3),'Value') == 0
    maskList = cellfun(@(x) ~isa(x,'impoint'),A.ply);
    i = find(maskList);
    for j = i
        try
            delete(F.pgon{1,j});
        catch
        end
    end
    try
        set(F.refPts,'Visible','off')
    catch
    end
end
end

%% This drop down list displays all drawn shapes including the entire figure
function [] = pu_call_1(varargin)
global S;
global A;
list_str = get(S.pu(1),'String');
list_val = get(S.pu(1),'Value');
list_len = length(list_str);
sz = size(A.ply);
for j = 1:sz(1,2)
    if ~isa(A.ply{1,j},'impoint')
        setColor(A.ply{1,j},'b');
    end
end
if (list_len > 1) && (list_val ~= 1)
    splt = strsplit(char(list_str(list_val)));
    mask_shape = splt{1,1};
    mask_num = str2num(splt{1,2}); %#ok<ST2NM>
    switch mask_shape
        case 'Polygon'
            maskType = 'impoly';
        case 'Rectangle'
            maskType = 'imrect';
        case 'Free_Hand'
            maskType = 'imfreehand';
        case 'Ellipse'
            maskType = 'imellipse';
    end
    match_list = {};
    i = 2;
    while i <= list_len
        if isa(A.ply{1,i-1},maskType) && isempty(match_list)
            if strcmp(maskType,'imrect') && isa(A.ply{1,i-1},'imellipse')
                i = i + 1;
                continue;
            end
            match_list{1,1} = A.ply{1,i-1};
        elseif isa(A.ply{1,i-1},maskType) && ~isempty(match_list)
            if strcmp(maskType,'imrect') && isa(A.ply{1,i-1},'imellipse')
                i = i + 1;
                continue;
            end
            match_list = [match_list,A.ply(1,i-1)]; %#ok<AGROW>
        end
        if length(match_list) == mask_num
            setColor(A.ply{1,i-1},'m');
            break
        end
        i = i + 1;
    end
end
end

%% Update the drop down list
function [] = pb_call_28(varargin)
global S;
global A;
% list_str = get(S.pu(1),'String');
% list_len = length(list_str);
polyNum = 0;
fhandNum = 0;
rectNum = 0;
elliNum = 0;
match_list = {};
rm_index = [];
for i = 1:length(A.ply)
    if ~isa(A.ply{1,i},'impoint')
        if isvalid(A.ply{1,i})
            tp = class(A.ply{1,i});
            switch tp
                case 'impoly'
                    maskShape = 'Polygon';
                    polyNum = polyNum + 1;
                    indx = polyNum;
                case 'imfreehand'
                    maskShape = 'Free_Hand';
                    fhandNum = fhandNum + 1;
                    indx = fhandNum;
                case 'imrect'
                    maskShape = 'Rectangle';
                    rectNum = rectNum + 1;
                    indx = rectNum;
                case 'imellipse'
                    maskShape = 'Ellipse';
                    elliNum = elliNum + 1;
                    indx = elliNum;
            end
            entry = strcat([maskShape,' ',num2str(indx)]);
            if isempty(match_list)
                match_list{1,1} = entry;
            elseif ~isempty(match_list)
                match_list = [match_list, entry]; %#ok<AGROW>
            end
        elseif ~isvalid(A.ply{1,i})
            tp = class(A.ply{1,i});
            %
            rm_index = [rm_index, i]; %#ok<AGROW>
            switch tp
                case 'impoly'
                    A.polygonNum = A.polygonNum - 1;
                case 'imfreehand'
                    A.freehandNum = A.freehandNum - 1;
                case 'imrect'
                    A.rectangleNum = A.rectangleNum - 1;
                case 'imellipse'
                    A.ellipseNum = A.ellipseNum - 1;
            end
        end
    end
end
for j = flip(rm_index)
    A.ply(:,j) = [];
end
match_list = ['Entire Figure', match_list];
set(S.pu(1),'String',match_list);
end

%% This button changes all data points within the previously defined mask on all frames to zero and replots the graph at frame 1
% NOTE: Excludes MPP and MVP graphs
function [] = pb_call_5(varargin) % Change Selected To Zero button
global S;
global D;
global A;
global F;
list_str = get(S.pu(1),'String');
list_val = get(S.pu(1),'Value');
list_len = length(list_str);
if list_val ~= 1
    if (list_len > 1) && (list_val ~= 1)
        splt = strsplit(char(list_str(list_val)));
        mask_shape = splt{1,1};
        mask_num = str2num(splt{1,2}); %#ok<ST2NM>
        switch mask_shape
            case 'Polygon'
                maskType = 'impoly';
            case 'Rectangle'
                maskType = 'imrect';
            case 'Free_Hand'
                maskType = 'imfreehand';
            case 'Ellipse'
                maskType = 'imellipse';
        end
        match_list = {};
        i = 2;
        while i <= list_len
            if isa(A.ply{1,i-1},maskType) && isempty(match_list)
                if strcmp(maskType,'imrect') && isa(A.ply{1,i-1},'imellipse')
                    i = i + 1;
                    continue;
                end
                match_list{1,1} = A.ply{1,i-1};
            elseif isa(A.ply{1,i-1},maskType) && ~isempty(match_list)
                if strcmp(maskType,'imrect') && isa(A.ply{1,i-1},'imellipse')
                    i = i + 1;
                    continue;
                end
                match_list = [match_list,A.ply(1,i-1)]; %#ok<AGROW>
            end
            if length(match_list) == mask_num
                Premask = A.ply{1,i-1};
                break
            end
            i = i + 1;
        end
    end
    A.BW = createMask(Premask,F.h);
    newMask = ~A.BW; % Inverts the selected coordinates from 1 to 0 and vice versa
    A.newForces = zeros(A.frames,1);
    for i = 1:A.frames
        D.data(:,:,i) = D.data(:,:,i).*newMask; % Multiplies the actual pressure data by the mask to achieve everything outside the mask
        A.newForces(i,1) = 0.25 * sum(sum(D.data(:,:,i))) / 10; % Calculate the new forces in Newtons
    end
    pb_call_25;
    set(S.pb(7),'callback',{@pb_call_7,S}); % Give functionality to the Recalculate CoP Data button
elseif list_val == 1
    msgbox({'In order to change selected data to zero across the entire data matrix, a mask needs to be selected.';
        'After changing selected to zero, select "Entire Figure" and hit "Recalculate CoP Data".';% Pop up warning
        'If you intend to calculate the local  CoP data under a mask, ';
        'select the desired mask and use the "Calculate Local CoP Data" button.'});
end
end

%% This button sums the selected pressures in the previously defined mask and marks the center of pressure of the mask
function [] = pb_call_6(varargin) %Sum Selected Pressures
global S;
global D;
global A;
global F;
list_str = get(S.pu(1),'String');
list_val = get(S.pu(1),'Value');
list_len = length(list_str);
if list_val ~= 1
    if (list_len > 1) && (list_val ~= 1)
        splt = strsplit(char(list_str(list_val)));
        mask_shape = splt{1,1};
        mask_num = str2num(splt{1,2}); %#ok<ST2NM>
        switch mask_shape
            case 'Polygon'
                maskType = 'impoly';
            case 'Rectangle'
                maskType = 'imrect';
            case 'Free_Hand'
                maskType = 'imfreehand';
            case 'Ellipse'
                maskType = 'imellipse';
        end
        match_list = {};
        i = 2;
        while i <= list_len
            if isa(A.ply{1,i-1},maskType) && isempty(match_list)
                if strcmp(maskType,'imrect') && isa(A.ply{1,i-1},'imellipse')
                    i = i + 1;
                    continue;
                end
                match_list{1,1} = A.ply{1,i-1};
            elseif isa(A.ply{1,i-1},maskType) && ~isempty(match_list)
                if strcmp(maskType,'imrect') && isa(A.ply{1,i-1},'imellipse')
                    i = i + 1;
                    continue;
                end
                match_list = [match_list,A.ply(1,i-1)]; %#ok<AGROW>
            end
            if length(match_list) == mask_num
                Premask = A.ply{1,i-1};
                break
            end
            i = i + 1;
        end
    end
    A.BW = createMask(Premask,F.h);
    if A.curDisplay == 1 % Execute if the normal pressure data is displayed
        tempData = D.data(:,:,A.CurFrameNum);
    elseif A.curDisplay == 0 % Execute if the MPP data is displayed
        tempData = A.MPPmat(:,:);
    elseif A.curDisplay == -1 % Execute if the MVP data is displayed
        tempData = A.MVPmat(:,:);
    end
    PressureSum = sum(sum(tempData(A.BW==1))); % Sum together all the pressures that are within the selected mask
    selectCoPmat = recalCoP(tempData.*A.BW,1); % Then recalculate the Center of Pressure matrix for all points within the selected mask
    for i = 1:A.frames
        A.CoPsequence = recalCoP(D.data.*A.BW,A.frames); % Calculate the Center of Pressure path within the masked area across all frames
    end
    begFrame = str2num(char(get(S.ed(4),'String'))); %#ok<ST2NM>
    endFrame = str2num(char(get(S.ed(5),'String'))); %#ok<ST2NM>
    tempMat = zeros(A.frames,5);
    for w = begFrame:endFrame
        for x = 2:3
            tempMat(w,x) = 1;
        end
    end
    for y = 1:A.frames
        for z = 2:3
            if tempMat(y,z) == 0
                tempMat(y,z) = NaN;
            end
        end
    end
    A.CoPsequence = A.CoPsequence .* tempMat;
    A.CoPcoord = [selectCoPmat(1,3)*2,selectCoPmat(1,2)*2]; % Create vectors for Center of Pressure coordinates for the points within the selected mask
    set(0, 'currentfigure', F.fig2); % Make sure the heat map is the current figure
    hold on;
    F.seqCoP = plot(A.CoPsequence(:,3)*2,A.CoPsequence(:,2)*2,'Color','m',...
        'LineWidth',1.5); % Map the newly calculated center of pressure path within the mask
    hold on
    F.selCoP = plot(A.CoPcoord(1,1),A.CoPcoord(1,2),'MarkerFaceColor','m',...
        'Marker','h','MarkerEdgeColor','k','MarkerSize',12); % Map the current center of pressure for the points within the selected mask
    fprintf('The sum of pressures selected is: %i kPa\n',PressureSum); % Print the sum of the selected pressures
    fprintf('The coordinates of the center of pressure of the\n selected area are: [ %f , %f ]\n',...
        A.CoPcoord(1,1),A.CoPcoord(1,2)); % Print the coordinates of the center of pressure
    A.copCalced_local = 1;
    set(S.cb(4),'Enable','on');
elseif list_val == 1
    msgbox({'In order to calculate local CoP data, a mask shape needs to be selected.'; % Pop up warning if used with another graph
        'If you intend to recalculate the CoP data for the entire data matrix, ';
        'select "Entire Figure" and use the "Recalculate CoP Data" button.'});
end
end

%% This checkbox allows for the newly calculated center of pressure data to remain graphed if the frame is changed
function [] = cb_call_4(varargin)
global S;
global F;
if S.cb(4).Value == 1
elseif S.cb(4).Value == 0
    set(0, 'currentfigure', F.fig2);
    hold on;
    delete(F.seqCoP)
    hold on;
    delete(F.selCoP)
end
end

%% This button graphs the MVP data
function [] = pb_call_17(varargin)
global S;
global D;
global A;
global F;
set(0, 'currentfigure', F.fig2); % Make sure the heat map is the current figure
hold on;
F.h_MVP = imagesc(A.MVPmat(:,:)); % Graphs the MPP data as a heat map on the figure
A.curDisplay = -1; %1 for Normal Data, 0 for MPP, -1 for MVP
colormap(jet); % Set the heat map color scheme to 'Jet'
colorbar; % Display the color bar on the right side of the map
highestNum = max(max(max(D.data))); % Use the highest pressure of all the frames to
caxis([0,highestNum]); % determine the highest number displayed by the color bar and make sure
set(S.cb(1),'Value',0); % the color scheme is consistent across all frames, then uncheck the Weight Text checkbox for speed purposes
if isfield(F,'hStrings')
    delete(F.hStrings);
end
Y_cp = A.CoPmat(:,3);
X_cp = A.CoPmat(:,2);
set(0, 'currentfigure', F.fig2);
hold on;
if S.cb(2).Value == 1
    F.CoPline = plot(2*Y_cp,2*X_cp,'color','k','LineWidth',2); % Graph the Center of Pressure line on top of the heat map
end
set(S.pb(11),'Visible','off')
set(S.pb(10),'Visible','off')
set(S.pb(9),'Visible','off')
set(S.pb(8),'Visible','off')
set(S.ed(1),'Position',[170 110 50 30])
set(S.pb(25),'Visible','on')
set(S.pb(25),'callback',{@pb_call_25,S});
set(S.pb(14),'Visible','off');
set(S.pb(19),'Visible','off');
set(S.pb(26),'Visible','off');
end

%% This button is to be used after using the Change Selected to Zero button to recalculate and map the Center of Pressure line
function [] = pb_call_7(varargin)
global S;
global D;
global A;
global F;
[A.CoPmat] = recalCoP(D.data,A.frames); % Recalculate the Center of Pressure matrix
delete(F.CoPline); % Delete the old Center of Pressure line
Y_cp = A.CoPmat(:,3);
X_cp = A.CoPmat(:,2);
set(0, 'currentfigure', F.fig2); % Make sure the heat map is the current figure
hold on;
F.CoPline = plot(2*Y_cp,2*X_cp,'color','k','LineWidth',2); % Graph the new Center of Pressure line
advanceCoP(A.CoPmat,A.CurFrameNum,F.fig2,S.cb(2).Value); % Graph the current Center of Pressure with a red star
end

%% This button is used to regraph the Total Force and Peak Pressure graphs after a mask has been zeroed
function [] = pb_call_32(varargin)
global F;
global A;
global D;
try
    delete(F.tf);
    F.tf = figure('CloseRequestFcn',@tfClose_call); % Create a separate figure to draw the graph in
    A.totForce = A.newForces;
    F.tfPlot = plot(1:A.frames,A.totForce); % Graph the Total Force across all frames
    title('Total Force');
    xlabel('Frame');
    ylabel('Force [N]');
catch
end
try
    delete(F.pp);
    F.pp=figure('CloseRequestFcn',@ppClose_call); % Create a separate figure to draw the graph in
    A.maxPressures = zeros(1,A.frames);
    for i = 1:A.frames
        A.maxPressures(1,i)=max(max(D.data(:,:,i)));
    end
    F.ppPlot = plot(1:A.frames,A.maxPressures); % Graph the Peak Pressure across all frames
    title('Peak Pressure');
    xlabel('Frame');
    ylabel('Force [kPa]'); %%N = (0.25*(sum(kPa)))/10
catch
end
end

%% This button selects the destination directory to which exported files are to be placed
function [] = pb_call_27(varargin) %Select Destination Directory
global S;
targetDir = uigetdir;
if targetDir ~= 0
    set(S.tx(15),'String',targetDir);
    set(S.an3,'Visible','on');
    set(S.pb(12),'Visible','on');
    set(S.pb(13),'Visible','on');
    set(S.pb(18),'Visible','on');
    set(S.ed(2),'Visible','on');
    set(S.ed(3),'Visible','on');
    set(S.tx(16),'Visible','off');
else
end
end

%% This button exports the newly calculated Center of Pressure Data in a .csv file with the desired name
function [] = pb_call_18(varargin) %Export New CoP Data
global S;
global A;
exportMat = round([A.newForces,A.CoPmat(:,2),A.CoPmat(:,3)],2); % Round the matrix data to the amount of significant figures displayed in the data file
fname = get(S.ed(2),'String');
fname = strcat(get(S.tx(15),'String'),'\',fname,'.csv'); % Extract the desired file name and add .csv to the end
T=array2table(exportMat,'VariableNames',{'Force_N','Y_pl','X_pl'}); % Turn the data into a table for formatting purposes
writetable(T,fname); % Write the data to the csv file
end

%% This button exports the entire Center of Pressure sequence of the masked area in a .csv file with the desired name
function [] = pb_call_12(varargin)
global S;
global A;
global D;
global F;
if A.copCalced_local == 1
    A.maskForces = zeros(A.frames,1);
    for i = 1:A.frames
        tempData = D.data(:,:,i);
        A.maskForces(i,1) = 0.25 * sum(sum(tempData(A.BW==1))) / 10;
    end
    begFrame = str2num(char(get(S.ed(4),'String'))); %#ok<ST2NM>
    endFrame = str2num(char(get(S.ed(5),'String'))); %#ok<ST2NM>
    tempMat = zeros(A.frames,5);
    for w = begFrame:endFrame
        for x = 1:3
            tempMat(w,x) = 1;
        end
    end
    for y = 1:A.frames
        for z = 2:3
            if tempMat(y,z) == 0
                tempMat(y,z) = NaN;
            end
        end
    end
    exportMat = [A.maskForces(:,1),A.CoPsequence(:,2),A.CoPsequence(:,3)]; % Assign data to usable matrix
    exportMat = exportMat .* tempMat(:,1:3);
    fname = get(S.ed(3),'String');
    fname = strcat(get(S.tx(15),'String'),'\',fname,'.csv'); % Extract the desired file name and add .csv to the end
    T=array2table(exportMat,'VariableNames',{'Force_N','Y_pl','X_pl'}); % Turn the data into a table for formatting purposes
    writetable(T,fname); % Write the data to the csv file
else
    beep;
    try
        figure(F.export1);
    catch
        F.export1 = msgbox({'<Export Masked CoP Sequence> may not be used until';
            '<Calculate Local CoP Data> is pressed.'},'Error','error'); % Display when user attempts to move outside frame range
    end
end
end

%% This button creates a copy of any .csv file Center of Pressure sequence altered to be relative to the Flashing LED
function [] = pb_call_13(varargin)
global S;
[FileName,PathName,~]=uigetfile('*.csv','MultiSelect','on'); % Open a window to select the data .csv file
if PathName == 0
else
    cd(PathName);
    if iscell(FileName) == 1
        for i = 1:length(FileName)
            num = xlsread(FileName{i});
            num(:,2) = num(:,2) - 14.7 - 47.5; % Alter the data so the origin is perceived to be at the Flashing LED
            num(:,3) = num(:,3) - 10.75;
            fname = FileName{i};
            fname = fname(1:end-4);
            fname = strcat(get(S.tx(15),'String'),'\',fname,'_relative.csv'); % Add the word 'relative' to the end to distinguish the clone from the original
            T = array2table(num,'VariableNames',{'Force_N','Y_pl','X_pl'}); % Turn the data into a table for formatting purposes
            writetable(T,fname); % Write the data to the csv file
        end
    elseif iscell(FileName) == 0
        num = xlsread(FileName);
        num(:,2) = num(:,2) - 14.7 - 47.5; % Alter the data so the origin is perceived to be at the Flashing LED
        num(:,3) = num(:,3) - 10.75;
        fname = FileName;
        fname = fname(1:end-4);
        fname = strcat(get(S.tx(15),'String'),'\',fname,'_relative.csv'); % Add the word 'relative' to the end to distinguish the clone from the original
        T = array2table(num,'VariableNames',{'Force_N','Y_pl','X_pl'}); % Turn the data into a table for formatting purposes
        writetable(T,fname); % Write the data to the csv file
    end
end
end

%% Reset GUI
function [] = pb_call_23(varargin)
global S;
global A;
set(S.sl(1),'value',0.1);
set(S.ed(6),'Enable','inactive');
set(S.ed(1),'Enable','inactive');
set(S.an1,'Visible','off');
set(S.pb(4),'Visible','off');
set(S.pb(5),'Visible','off');
set(S.pb(6),'Visible','off');
set(S.pb(7),'Visible','off');
set(S.pb(20),'Visible','off');
set(S.pb(21),'Visible','off');
set(S.pb(22),'Visible','off');
set(S.ed(4),'Visible','off');
set(S.ed(5),'Visible','off');
set(S.tx(13),'Visible','off');
set(S.tx(14),'Visible','off');
set(S.tx(19),'Visible','off');
set(S.tx(20),'Visible','off');
set(S.cb(3),'Visible','off');
set(S.cb(4),'Visible','off');
set(S.pb(28),'Visible','off');
set(S.cb(1),'Enable','inactive');
set(S.cb(2),'Enable','inactive');
set(S.cb(3),'Enable','inactive');
set(S.pb(2),'Enable','inactive');
set(S.pb(3),'Enable','inactive');
set(S.pb(16),'Enable','inactive');
set(S.pb(17),'Enable','inactive');
set(S.pb(8),'Enable','inactive');
set(S.pb(9),'Enable','inactive');
set(S.pb(10),'Enable','inactive');
set(S.pb(11),'Enable','inactive');
set(S.pb(14),'Enable','inactive');
set(S.pb(19),'Enable','inactive');
set(S.pb(26),'Enable','inactive');
set(S.sl(1),'Enable','inactive');
set(S.pu(1),'Visible','off');
A.polyCoor = {0,0};
A.ply = {};
A.polygonNum = 0;
A.freehandNum = 0;
A.rectangleNum = 0;
A.ellipseNum = 0;
A.playSpeed = 0.1;
A.playState = true;
A.copHold = 0;
A.copCalced_local = 0;
set(S.tx(18),'Visible','on');
set(S.tx(15),'String','Directory: ');
set(S.pb(12),'Visible','off');
set(S.pb(13),'Visible','off');
set(S.pb(18),'Visible','off');
set(S.ed(2),'Visible','off');
set(S.ed(3),'Visible','off');
set(S.tx(16),'Visible','on');
set(S.tx(3),'String','000');
set(S.tx(12),'String',"File Name: ");
set(S.ed(1),'String','Frame')
end

%% Save Session
function [] = pb_call_24(varargin)

end
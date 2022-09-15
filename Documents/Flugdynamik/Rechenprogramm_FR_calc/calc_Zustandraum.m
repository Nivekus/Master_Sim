%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% Technische Universität Berlin - Fakultät V                              %
% Institut für Luft- und Raumfahrttechnik                                 %
% Fachgebiet Flugmechanik, Flugregelung und Aeroelastizität               %
% Prof. Dr.-Ing. Robert Luckner                                           %
%                                                                         %
% Projektname:      FR_calc - Berechnungstool für das Buch Flugregelung   %
% Datei:            calc_Zustandsraum.m                                   %
% Zweck:            Berechnung der Zustandsraummatrizen                   %
%                                                                         %
% Autoren:          Prof. Dr.-Ing. Robert Luckner                         %  
%                   Dipl.-Ing. Andrej Schönfeld                           %
%                   Alexander Köthe, B.Sc.                                %
%                   cand.-Ing. Fadi Bitar                                 %
%                                                                         %
% Version :         1.0                                                   %
% Datum   :         28.10.2011                                            %
%                                                                         %
%_________________________________________________________________________%
%                                                                         %
% Revisionen                                                              %
% ----------                                                              %
% Nr.  Datum     Autor          Änderung                                  %
% ---  --------  -------------  ---------------------------------------   %
%                                                                         %
%_________________________________________________________________________%
%                                                                         %
% Alle Daten in SI-Einheiten, Winkel werden in Grad ein- und ausgegeben,  %
% müssen aber programmintern in das Bogenmaß umgerechnet werden           %
%                                                                         %
% externe Variable                                                        %
% ----------------                                                        %
% Eingangsgrößen:  Fall         - Bewegungsform; 1 = LB; 2 = SB           %
%                  EZ           - Ersatzgroessen                          %
%                  FZ           - Flugzstandsparameter                    % 
% Ausgabgsgrößen:  Zustandsraum - Zustandsraum                            %
%                                                                         %
%_________________________________________________________________________%
%                                                                         %
% interne Variable                                                        %
% ----------------                                                        %
%               Bezeichnung im Buch                                       %
% Matlab        (TeX-Rohformat)       Bedeutung                           %
% -------       ------------------    ----------------------------------- %
% A             \underline{A}         Systemmatrix                        %
% B             \underline{B}         Steuermatrix                        %
% C             \underline{C}         Beobachtungsmatrix                  %
% D             \underline{D}         Durchgangsmatrix                    %
% Mq            M_q                   Nickmoment infolge einer Nickrate   %
% Mal           M_{\alpha}            Nickmoment infolge eines Anstell-   %
%                                     winkels                             %
% Mu            M_u                   Nickmoment infolge der Geschwindig- %
%                                     keit in x-Richtung                  %
% Zal           Z_{\alpha}            Kraft in z-Richtung infolge eines   %
%                                     Anstellwinkels                      %
% Zthe          Z_{\Theta}            Kraft in z-Richtung infolge eines   %
%                                     Längslagewinkels                    %
% Zu            Z_u                   Kraft in z-Richtung infolge einer   %
%                                     Geschwindigkeit in x-Richtung       %
% Xal           X_{\alpha}            Kraft in x-Richtung infolge eines   %
%                                     Anstellwinkels                      %
% Xthe          X_{\Theta}            Kraft in x-Richtung infolge eines   %
%                                     Längslagewinkels                    %
% Xu            X_u                   Kraft in x-Richtung infolge einer   %
%                                     Geschwindigkeit in x-Richtung       %
% Mf            M_f                   Nickmoment infolge des Schubes      %
% Mkap          M_{\kappa}            Nickmoment infolge eines Klappen-   %
%                                     ausschlages                         %
% Met           M_{\eta}              Nickmoment infolge eines Höhenruder-%
%                                     ausschlages                         %
% Xf            X_f                   Kraft in x-Richtung infolge des     %
%                                     Schubes                             %
% Xkap          X_{\kappa}            Kraft in x-Richtung infolge eines   %
%                                     Klappenausschlages                  %
% Xet           X_{\eta}              Kraft in x-Richtung infolge eines   %
%                                     Höhenruderausschlages               %
% Zf            Z_f                   Kraft in z-Richtung infolge des     %
%                                     Schubes                             %
% Zkap          Z_{\kappa}            Kraft in z-Richtung infolge eines   %
%                                     Klappenausschlages                  %
% Zet           Z_{\eta}              Kraft in z-Richtung infolge eines   %
%                                     Höhenruderausschlages               %
% Nbet          N_{\beta}             Giermoment infolge eines Schiebe-   %
%                                     winkels                             %
% Nr            N_r                   Giermoment infolge einer Gierrate   %
% Ybet          Y_{\beta}             Querkraft infolge eines Schiebe-    %
%                                     winkels                             %
% Lbet          L_{\beta}             Rollmoment infolge eines Schiebe-   %
%                                     winkels                             %
% Lr            L_r                   Rollmoment infolge einer Gierrate   %
% Nxi           L_{\xi}               Giermoment infolge eines Querruder- %
%                                     ausschlages                         %
% Nzeta         L_{\zeta}             Giermoment infolge eines Seiten-    %
%                                     ruderausschlages                    %
% Lxi           L_{\xi}               Rollmoment infolge eines Querruder- %
%                                     ausschlages                         %
% Lzeta         L_{\zeta}             Rollmoment infolge eines Seiten-    %
%                                     ruderausschlages                    %
% al_r          \alpha_R              Referenzanstellwinkel               %
% ga_r          \gamma_R              Referenzbahnneigungswinkel          %
% V_r           V_R                   Referenzgeschwindigkeit             %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%% Hauptfunktion

function Zustandsraum = calc_Zustandraum(Fall,EZ,FZ)

% Fallunterscheidung, welchen Bewegungsform vorliegt
if (Fall == 1)
    % Längsbewegung
    Zustandsraum = ZustandsraumLB(EZ,FZ);
elseif (Fall == 2)
    % Seitenbewegung
    Zustandsraum = ZustandsraumSB(EZ,FZ);
else
    % Fehlerfall
    Zustandsraum = 0;
end
end

function Zustandsraum = ZustandsraumLB(EZ,FZ)

A = [EZ.Mq                       EZ.Mal   EZ.Mu   0
                     1   EZ.Zal+EZ.Zthe   EZ.Zu   EZ.Zthe
                     0   EZ.Xal+EZ.Xthe   EZ.Xu   EZ.Xthe
                     0  -EZ.Zal-EZ.Zthe  -EZ.Zu  -EZ.Zthe];

B= [ EZ.Mf   EZ.Meta
     EZ.Zf   EZ.Zeta
     EZ.Xf   EZ.Xeta
    -EZ.Zf  -EZ.Zeta];

C = eye(4);
D = zeros(4,2);

Zustandsraum = ss(A,B,C,D,...
    'StateName',{'q'    ,'\alpha','V'  ,'\gamma'},...
    'StateUnit',{'deg/s','deg'   ,'m/s','deg'},...
    'OutputName',{'q'    ,'\alpha','V'  ,'\gamma'},...
    'OutputUnit',{'deg/s','deg'   ,'m/s','deg'},...
    'InputName',{'f','\eta'},...
    'InputUnit',{'-','deg'},...
    'TimeUnit','seconds',...
    'Name','Längsbewegung',...
    'notes',FZ.Bezeichnung);
end

function Zustandsraum = ZustandsraumSB(EZ,FZ)
g  = 9.80665;

A = [             EZ.Nr  EZ.Nbet  EZ.Np           0
                     -1  EZ.Ybet      0   (g/FZ.V_r)
                  EZ.Lr  EZ.Lbet  EZ.Lp           0
    (FZ.al_r + FZ.ga_r)        0      1           0];

B= [EZ.Nxi   EZ.Nzeta
         0   EZ.Yzeta
    EZ.Lxi   EZ.Lzeta
         0          0];

C = eye(4);
D = zeros(4,2);

Zustandsraum = ss(A,B,C,D,...
    'Statename',{'r'    ,'\beta', 'p'    , '\Phi'},...
    'StateUnit',{'deg/s','deg'  , 'deg/s', 'deg' },...
    'OutputName',{'r'    ,'\beta', 'p'    , '\Phi'},...
    'OutputUnit',{'deg/s','deg'  , 'deg/s', 'deg' },...
    'InputName',{'\xi','\zeta'},...
    'InputUnit',{'deg','deg'}  ,...
    'TimeUnit','seconds',...
    'Name','Seitenbewegung',...
    'notes',FZ.Bezeichnung);
end
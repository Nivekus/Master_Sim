%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% Technische Universität Berlin - Fakultät V                              %
% Institut für Luft- und Raumfahrttechnik                                 %
% Fachgebiet Flugmechanik, Flugregelung und Aeroelastizität               %
% Prof. Dr.-Ing. Robert Luckner                                           %
%                                                                         %
% Projektname:      FR_calc - Berechnungstool für das Buch Flugregelung   %
% Datei:            calc_Sprungantwort.m                                  %
% Zweck:            Bestimmung der Sprungantworten                        %
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
% Eingangsgrößen:  ZR            - Zustandsraum                           %
%                  Verzeichnis   - Verzeichnis, in dem die Plots          %
%                                  gespeichert werden                     %
%                  Fall          - Bewegungsform; 1 = LB; 2 = SB          %
%                  AlleFlugzeuge - Auswahl                                %
%                                  (1 - ein Flugzeug; 2 - alle Flugzeuge) %
%                  prefix        - Praefix für Fall und Bewegungsform     %
% Ausgangsgrößen:  Sprungantwort - Sprungantwort                          %
%                                                                         %
%_________________________________________________________________________%
%                                                                         %
% interne Variable                                                        %
% ----------------                                                        %
%               Bezeichnung im Buch                                       %
% Matlab        (TeX-Rohformat)       Bedeutung                           %
% -------       ------------------    ----------------------------------- %
% Error         ---                   Fehlercode                          %
% Auswahl       ---                   String Eingabe durch den Nutzer     %
% auxauswahl    ---                   Integer Wert der Nutzereingabe      %
% i             ---                   Zählvariable                        %
% j             ---                   Zählvariable                        %
% Werte         ---                   Antworten des Systems               %
% Langzeit-     ---                   Antworten für die Langzeitdynamik   %
% dynamik                                                                 %
% Kurzzeit-     ---                   Antworten für die Kurzzeitdynamik   %
% dynamik                                                                 %
% InputName     ---                   Bezeichnung der Steuergröße         %
% StateName     ---                   Bezeichnung der Zustandsgröße       %
% t_kd          t                     Zeit (Kurzzeitdynamik) [0,20s]      %
% u_kd          u                     Sprungeingang (Kurzzeitdynamik)     %
% t_ld          t                     Zeit (Kurzzeitdynamik) [0,120s]     %
% u_ld          u                     Sprungeingang (Langzeitdynamik)     %
% x             x                     Zustandsgröße                       %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Hauptfunktion

function Sprungantwort = calc_Sprungantwort(ZR,Verzeichnis,Fall,AlleFlugzeuge,prefix)
if Fall == 1
    Bewegung='Längsbewegung';
else
    Bewegung='Seitenbewegung';
end

%Abfrage ob Sprungantwort geplottet werden soll
if AlleFlugzeuge~=2
    % Grafische Darstellung der Sprungantworten
    disp(' ');
    disp('Sollen die Sprungantworten grafisch dargestellt werden?');
    disp('1 - ja');
    disp('2 - nein');
    disp(' ');
    % Abfrage zur Eingabe
    Error = 1;
    while (Error == 1)
        Auswahl = input('Ihre Auswahl: ','s');
        Error = Darstellungsauswahl(Auswahl);
        if (Error ~= 1)
            auxAuswahl = str2double(Auswahl);
        end
    end
else
    auxAuswahl = 1;
end

%% Berechnung des Eingangssignals für die Kurzzeitdynamik
% Sprung nach einer Sekunde auf den Wert 1
i=0;
t_kd = zeros(1,201);
u_kd = zeros(1,201);
for time=0:0.1:20
    i = i+1;
    t_kd(i) = time;
    if time >= 1
        u_kd(i) = 1;
    else
        u_kd(i) = 0;
    end
end

%% Berechnung des Eingangssignals für die Langzeitdynamik
% Sprung nach einer Sekunde auf 1
i=0;
t_ld = zeros(1,601);
u_ld = zeros(1,601);
for time=0:0.2:120
    i = i+1;
    t_ld(i) = time;
    if time >= 1
        u_ld(i) = 1;
    else
        u_ld(i) = 0;
    end
end

%% Abspeichern der Werte für Zeit und Eingangsgröße
Sprungantwort.t_kurzzeitdynamik = t_kd;
Sprungantwort.t_langzeitdynamik = t_ld;
Sprungantwort.u_kurzzeitdynamik = u_kd;
Sprungantwort.u_langzeitdynamik = u_ld;

% Bestimmen der Anzahl von Zustands- und Steuergrößen
[state,Input] = size(ZR.b);

%% Simulation der Kurzzeitdynamik
for i=1:Input
    for j=1:state
        % Simulation der Zustandsgrößen
        if strcmp(ZR.InputUnit{i},'deg')
            factor = 1.0;
            [x,t] = lsim(ZR(j,i),u_kd*pi/180,t_kd); % deg in rad (Stellflächen)
        elseif strcmp(ZR.InputUnit{i},'-')
            factor = 0.1;
            [x,t] = lsim(ZR(j,i),u_kd*factor,t_kd); % Reduktion auf 0.1 (Schub)
        end
        Sprungantwort.Kurzzeitdynamik(i,j).Werte = x;
        Sprungantwort.Kurzzeitdynamik(i,j).InputName = ZR.InputName{i};
        Sprungantwort.Kurzzeitdynamik(i,j).StateName = ZR.StateName{j};
        
        if auxAuswahl == 1
            %Darstellung der Simulationsergebnisse
            if j==1
                h = figure('Name',(['Kurzzeitdynamik Sprungantworten für ',ZR.InputName{i}]),'units','normalized','outerposition',[0 0 1 1]);
                subplot((state+1),1,1)
                % Plotten der Anregung
                plot(t_kd,u_kd*factor,'b','LineWidth',2);
                hold on;
                ylabel([ZR.InputName{i},' [',ZR.InputUnit{i},']']);
                grid on;
                title([prefix,' - ',Bewegung,': Sprungantworten für ',ZR.InputName{i}])
            end
            subplot((state+1),1,j+1)
            %für Ausgabe: Umrechnen in deg
            if strcmp(ZR.StateUnit{j},'deg') || strcmp(ZR.StateUnit{j},'deg/s')
                conv=180/pi;
            else
                conv=1;
            end
            plot(t,x*conv,'LineWidth',2);
            hold on;
            grid on;
            ylabel([ZR.StateName{j},' [',ZR.StateUnit{j},']']);
            if j==state
                xlabel('Zeit in s');
            end
        end
    end
    
    if auxAuswahl == 1
        if (exist([Verzeichnis,'\Grafiken'],'dir') == 0)
            mkdir([Verzeichnis,'\Grafiken']);
        end
        % Abspeichern der Plots als Grafik
        Inputname = ZR.InputName{i};
        orient landscape
        if strcmp(Inputname(1),'\')
            print(h,'-dpdf','-r300',[Verzeichnis,'\Grafiken\',prefix,' - Kurzzeitdynamik Sprungantworten für ',Inputname(2:length(Inputname))]);
        else
            print(h,'-dpdf','-r300',[Verzeichnis,'\Grafiken\',prefix,' - Kurzzeitdynamik Sprungantworten für ',Inputname]);
        end
    end
end
%% Simulation der Langzeitdynamik
for i=1:Input
    for j=1:state
        % Simulation der Zustandsgrößen
        if strcmp(ZR.InputUnit{i},'deg')
            factor = 1.0;
            [x,t] = lsim(ZR(j,i),u_ld*pi/180,t_ld); % deg in rad (Stellflächen)
        elseif strcmp(ZR.InputUnit{i},'-')
            factor = 0.1;
            [x,t] = lsim(ZR(j,i),u_ld*factor,t_ld); % Reduktion auf 0.1 (Schub)
        end
        Sprungantwort.Langzeitdynamik(i,j).Werte = x;
        Sprungantwort.Langzeitdynamik(i,j).InputName = ZR.InputName{i};
        Sprungantwort.Langzeitdynamik(i,j).StateName = ZR.StateName{j};
        
        if auxAuswahl == 1
            %Darstellung der Simulationsergebnisse
            if j==1
                h = figure('Name',(['Langzeitdynamik Sprungantworten für ',ZR.InputName{i}]),'units','normalized','outerposition',[0 0 1 1]);
                subplot((state+1),1,1)
                % Plotten der Anregung
                plot(t_ld,u_ld*factor,'b','LineWidth',2);
                hold on;
                ylabel([ZR.InputName{i},' [',ZR.InputUnit{i},']']);
                grid on;
                title([prefix,' - ',Bewegung,': Sprungantworten für ',ZR.InputName{i}])
            end
            subplot((state+1),1,j+1)
            if strcmp(ZR.StateUnit{j},'deg') || strcmp(ZR.StateUnit{j},'deg/s')
                conv=180/pi;
            else
                conv=1;
            end
            plot(t,x*conv,'LineWidth',2);
            hold on;
            grid on;
            ylabel([ZR.StateName{j},' [',ZR.StateUnit{j},']']);
            if j==state
                xlabel('Zeit in s');
            end
        end
    end
    
    
    if auxAuswahl == 1
        if (exist([Verzeichnis,'\Grafiken'],'dir') == 0)
            mkdir([Verzeichnis,'\Grafiken']);
        end
        
        % %Ausgabe der Sprungantwort in pdf-Datei 
        Inputname = ZR.InputName{i};
        orient landscape
        if strcmp(Inputname(1),'\')
            print(h,'-dpdf','-r300',[Verzeichnis,'\Grafiken\',prefix,' - Langzeitdynamik Sprungantworten für ',Inputname(2:length(Inputname))]);
        else
            print(h,'-dpdf','-r300',[Verzeichnis,'\Grafiken\',prefix,' - Langzeitdynamik Sprungantworten für ',Inputname]);
        end
    end
end

if auxAuswahl == 1 && AlleFlugzeuge ~= 2
    disp('Bitte mit beliebiger Taste fortsetzen...');
    pause;
end
close all;

end

function Error = Darstellungsauswahl(Auswahl)

if (strcmp(Auswahl,'1') || strcmp(Auswahl,'2'))
    Error = 0;
else
    disp(' ');
    disp('Ihre Eingabe konnte nicht zugeordnet werden. Bitte wiederholen Sie Ihre Eingabe!');
    disp('1 - Darstellung');
    disp('2 - Ohne Darstellung fortfahren');
    disp(' ');
    Error = 1;
end
end

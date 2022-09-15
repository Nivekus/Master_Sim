%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% Technische Universität Berlin - Fakultät V                              %
% Institut für Luft- und Raumfahrttechnik                                 %
% Fachgebiet Flugmechanik, Flugregelung und Aeroelastizität               %
% Prof. Dr.-Ing. Robert Luckner                                           %
%                                                                         %
% Projektname:      FR_calc - Berechnungstool für das Buch Flugregelung   %
% Datei:            select_Flugzeug.m                                             %
% Zweck:            Auswahl eines Flugzeugs zur Berechnung                %
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
% Eingangsgrößen:  AlleFlugzeuge - Auswahl                                %
%                                  (1 - ein Flugzeug; 2 - alle Flugzeuge  %
% Ausgabgsgrößen:  Error         - Fehlercode                             %
%                  mat-Dateien   - Ergebnisstrukturen                     %
%                                                                         %
%_________________________________________________________________________%
%                                                                         %
% interne Variable                                                        %
% ----------------                                                        %
%               Bezeichnung im Buch                                       %
% Matlab        (TeX- Rohformat)      Bedeutung                           %
% -------       ------------------    ----------------------------------- %
% Error         ---                   Fehlercode                          %
% Auswahl       ---                   String Eingabe durch den Nutzer     %
% auxauswahl    ---                   Auswahl des Flugzeugtyps            %
% a             ---                   Hilfsstring                         %
% auxBewe-      ---                   Auswahl der Bewegungsform           %
% gungsform                                                               %
% EZ            ---                   Ersatzgrößen (Struktur)             %
% EZLB          ---                   Ersatzgrößen der Längsbewegung      %
%                                     (Struktur)                          %
% EZSB          ---                   Ersatzgrößen der Seitenbewegung     %
%                                     (Struktur)                          %
% ZR            ---                   Zustandsraum (Struktur)             %
% UF            ---                   Übertragungsfunktionen (Struktur)   %
% Eigenver-     ---                   Struktur mit Eigenvektoren und      %
% verhalten                           Eigenwerten                         %
% EV            ---                   Eigenvektor                         %
% EW            ---                   Eigenwert                           %
% SAW           ---                   Sprungantworten (Struktur)          %
% i             ---                   Zählschleife                        %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Beginn Hauptprogramm

function Error = select_Flugzeug(AlleFlugzeuge)

% Laden der Derivative
get_Derivative;

% ErrorVariable (1 - Fehler, 0 - kein Fehler)
Error = 1;

disp(' ');
disp('Flugzeugauswahl');
disp('---------------');
disp(' ');
disp(' A - Airbus A300');
disp(' B - Boeing 707');
disp(' C - Concorde');
disp(' D - Dornier Do328');
disp(' F - Lockheed F104G');
disp(' Q - Programm beenden');
disp(' ')

% Auswahl des Flugzeugtyps
while (Error == 1)
    Auswahl = input('Bitte wählen Sie die ein Flugzeug aus [A-D,F] oder beenden Sie das Programm [Q] : ','s');
    Error = Flugzeugauswahl(Auswahl);
    if (Error ~= 1)
        if strcmp(Auswahl,'A') 
            auxAuswahl = 1;
        end
        if strcmp(Auswahl,'B') 
            auxAuswahl = 2;
        end
        if strcmp(Auswahl,'C') 
            auxAuswahl = 3;
        end
        if strcmp(Auswahl,'D') 
            auxAuswahl = 4;
        end
        if strcmp(Auswahl,'F') 
            auxAuswahl = 5;
        end
        if strcmp(Auswahl,'Q')
            auxAuswahl = 6;
        end
    end
end

if (auxAuswahl == 6)
    % Beenden des Programms
    Error = -1;
    return;
end

% Ordner mit Namen des Flugzeugs erstellen, falls noch nicht vorhanden
if (exist(AC(auxAuswahl).Name,'dir') == 0)
   mkdir(AC(auxAuswahl).Name);
end

Verzeichnis = AC(auxAuswahl).Name;

disp(' ');
disp('Auswahl der Bewegungsform');
disp('-------------------------');
disp(' ');
disp(' 1 - Längsbewegung');
disp(' 2 - Seitenbewegung');
disp(' 3 - Ende');
disp(' '); 

% Auswahl der Bewegungsform
Error = 1;
while (Error == 1)
     Auswahl = input('Bitte wählen Sie die eine Bewegungsform [1-2] oder beenden Sie das Programm [3] : ','s');
     Error = Bewegungsauswahl(Auswahl);
     if (Error ~= 1)
         auxBewegungsform = str2double(Auswahl);
     end
end

if (auxBewegungsform == 3)
    % Beenden des Programms
    Error = -1;
    return;
end

% Auswahl des Flugzustandes
disp(' ');
disp('Auswahl des Flugzustandes');
disp('-------------------------');
disp(' ');
for n= 1:3
    a = [' ',num2str(n),' - ',FZ(3*(auxAuswahl-1)+n).Bezeichnung];
    disp(a);
end
disp(' 4 - Ende');
disp(' ');
    
Error = 1;
while (Error == 1)
     Auswahl = input('Bitte wählen Sie die einen Flugzustand [1-3] oder beenden Sie das Programm [4] : ','s');
     Error = Flugzustandsauswahl(Auswahl);
     if (Error ~= 1)
         auxFlugzustand = str2double(Auswahl);
     end
end

if (auxFlugzustand == 4)
    % Beenden des Programms
    Error = -1;
    return;
end

%% Ersatzgroessen
clc;

%Praefix für Fall und Bewegungsform bestimmen
prefix=[AC(auxAuswahl).Name,' - ',FZ(3*(auxAuswahl-1)+auxFlugzustand).Kuerzel];

% Berechnen der Ersatzgroessen
EZ = calc_Ersatzgroessen(auxBewegungsform,AC(auxAuswahl),FZ(3*(auxAuswahl-1)+auxFlugzustand));
disp('Ersatzgroessen erfolgreich berechnet');

% Speichern der Ersatzgroessen
if auxBewegungsform == 1
    a = [AC(auxAuswahl).Name,'\',FZ(3*(auxAuswahl-1)+auxFlugzustand).Kuerzel,'_LB_Ersatzgroessen.mat'];
else
    a = [AC(auxAuswahl).Name,'\',FZ(3*(auxAuswahl-1)+auxFlugzustand).Kuerzel,'_SB_Ersatzgroessen.mat'];
end
save(a,'EZ');
disp('Ersatzgroessen erfolgreich gespeichert');

%% Zustandsraum
% Berechnen des Zustandsraumes
ZR = calc_Zustandraum(auxBewegungsform,EZ,FZ(3*(auxAuswahl-1)+auxFlugzustand));
disp(' ');
disp('Zustandsraum erfolgreich erzeugt');

% Speichern des Zustandsraumes
if auxBewegungsform == 1
    a = [AC(auxAuswahl).Name,'\',FZ(3*(auxAuswahl-1)+auxFlugzustand).Kuerzel,'_LB_Zustandsraum.mat'];
else
    a = [AC(auxAuswahl).Name,'\',FZ(3*(auxAuswahl-1)+auxFlugzustand).Kuerzel,'_SB_Zustandsraum.mat'];
end
save(a,'ZR');
disp('Zustandsraum erfolgreich gespeichert');

%% Übertragungsfunktionen

% Berechnen der Übertragungsfunktion
disp(' ');
disp('Übertragungsfunktionen');
disp('----------------------');
UF = calc_Uebertragungsfunktion(auxBewegungsform,ZR,Verzeichnis,AlleFlugzeuge,prefix);
disp(' ');
disp('Übertragungsfunktionen erfolgreich erzeugt');

% Speichern der Übertragungsfunktionen
if auxBewegungsform == 1
    a = [AC(auxAuswahl).Name,'\',FZ(3*(auxAuswahl-1)+auxFlugzustand).Kuerzel,'_LB_Uebertragungsfunktion.mat'];
else
    a = [AC(auxAuswahl).Name,'\',FZ(3*(auxAuswahl-1)+auxFlugzustand).Kuerzel,'_SB_Uebertragungsfunktion.mat'];
end
save(a,'UF');
disp('Übertragungsfunktionen erfolgreich gespeichert');

%% Eigenwerte, Eigenvektoren und Pol-Nullstellen-Darstellung
% Bestinmmen von Eigenwerte, Eigenvektoren und Pol- Nullstellen Darstellung
disp(' ');
disp('Eigenwerte, Eigenvektoren und Pol-Nullstellen-Darstellung');
disp('---------------------------------------------------------');
[Eigenverhalten.EV,Eigenverhalten.EW] = calc_Eigenwerte(auxBewegungsform,UF,ZR,Verzeichnis,AlleFlugzeuge,prefix);

disp(' ');
disp('Eigenwerte und Eigenvektoren erfolgreich erzeugt');

% Speichern der Eigenwerte und Eigenvektoren
if auxBewegungsform == 1
    a = [AC(auxAuswahl).Name,'\',FZ(3*(auxAuswahl-1)+auxFlugzustand).Kuerzel,'_LB_Eigenverhalten.mat'];
else
    a = [AC(auxAuswahl).Name,'\',FZ(3*(auxAuswahl-1)+auxFlugzustand).Kuerzel,'_SB_Eigenverhalten.mat'];
end
save(a,'Eigenverhalten');
disp('Eigenwerte und Eigenvektoren erfolgreich gespeichert');

%% Sprungantworten
% Bestimmen von Eigenwerten, Eigenvektoren und Pol- Nullstellen Darstellung
disp(' ');
disp('Sprungantworten');
disp('----------------');

SAW = calc_Sprungantwort(ZR,Verzeichnis,auxBewegungsform,AlleFlugzeuge,prefix);

disp(' ');
disp('Sprungantworten erfolgreich erzeugt');

% Speichern der Sprungantworten
if auxBewegungsform == 1
    a = [AC(auxAuswahl).Name,'\',FZ(3*(auxAuswahl-1)+auxFlugzustand).Kuerzel,'_LB_Sprungantworten.mat'];
else
    a = [AC(auxAuswahl).Name,'\',FZ(3*(auxAuswahl-1)+auxFlugzustand).Kuerzel,'_SB_Sprungantworten.mat'];
end
save(a,'SAW');
disp('Sprungan erfolgreich gespeichert');

%% Wurzelortskurven
disp(' ');
disp('Wurzelortskurven');
disp('----------------');
disp(' ');
calc_WOK(ZR,Verzeichnis,AlleFlugzeuge,prefix);
disp(' ');

clc
Error = 0;

end

function Error = Flugzeugauswahl(Auswahl)

if (strcmp(Auswahl,'A') || strcmp(Auswahl,'B') || strcmp(Auswahl,'C') || strcmp(Auswahl,'D') || strcmp(Auswahl,'F') || strcmp(Auswahl,'Q'))
    Error = 0;
else
    disp(' ');
    disp('Ihre Eingabe konnte nicht zugeordnet werden. Bitte wiederholen Sie Ihre Eingabe!');
    disp('[A-D,F]: Flugzeuge');
    disp('[Q]    : Programmende');
    disp(' ');
    Error = 1;
end
end

function Error = Bewegungsauswahl(Auswahl)

if (strcmp(Auswahl,'1') || strcmp(Auswahl,'2') || strcmp(Auswahl,'3'))
    Error = 0;
else
    disp(' ');
    disp('Ihre Eingabe konnte nicht zugeordnet werden. Bitte wiederholen Sie Ihre Eingabe!');
    disp('[1-2]: Bewegungsform');
    disp('[6]  : Programmende');
    disp(' ');
    Error = 1;
end
end

function Error = Flugzustandsauswahl(Auswahl)

if (strcmp(Auswahl,'1') || strcmp(Auswahl,'2') || strcmp(Auswahl,'3') || strcmp(Auswahl,'4'))
    Error = 0;
else
    disp(' ');
    disp('Ihre Eingabe konnte nicht zugeordnet werden. Bitte wiederholen Sie Ihre Eingabe!');
    disp('[1-3]: Flugzustand');
    disp('[4]  : Programmende');
    disp(' ');
    Error = 1;
end
end


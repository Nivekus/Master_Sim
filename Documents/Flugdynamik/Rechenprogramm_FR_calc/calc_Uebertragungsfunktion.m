%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% Technische Universität Berlin - Fakultät V                              %
% Institut für Luft- und Raumfahrttechnik                                 %
% Fachgebiet Flugmechanik, Flugregelung und Aeroelastizität               %
% Prof. Dr.-Ing. Robert Luckner                                           %
%                                                                         %
% Projektname:      FR_calc - Berechnungstool für das Buch Flugregelung   %
% Datei:            calc_Uebertragungsfunktion.m                          %
% Zweck:            Bestimmung der Übertragungsfunktionen                 %
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
% Eingangsgrößen:  Fall                    - Bewegungsform; 1 = LB; 2 = SB%
%                  Zustandsraum            - Zustandsraum                 %
%                  Verzeichnis             - Verzeichnis, in dem die Plots%
%                                            gespeichert werden           %
%                  AlleFlugzeuge - Auswahl                                %
%                                  (1 - ein Flugzeug; 2 - alle Flugzeuge) %
%                  prefix        - Praefix für Fall und Bewegungsform     %
% Ausgangsgrößen:  Uebertragungsfunktionen - Übertragungsfunktionen       %
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
% o1            ---                   Frequenzbereich von 10^-3 - 10^-2   %
% o2            ---                   Frequenzbereich von 10^-2 - 10^-1   %
% o3            ---                   Frequenzbereich von 10^-1 - 10^0    %
% o4            ---                   Frequenzbereich von 10^0  - 10^1    %
% o5            ---                   Frequenzbereich von 10^1  - 10^2    %
% ome           ---                   Logarithmische Frequenzaufteilung   %
%                                     durch o1-o5                         %
% Amp           ---                   Amplitude aus der MATLAB "Bode"     %
%                                     Funktion                            %
% Pha           ---                   Phasenlage aus der MATLAB "Bode"    %
%                                     Funktion                            %
% aux1          ---                   Übertragungsfunktion im Format      %
%                                     Verstärkung - Pole - Nullstellen    %
% K             ---                   Verstärkungsfaktor                  %
% pmax          ---                   maximale Amplitude im Bodediagramm  %
% pmin          ---                   minimale Amplitude im Bodediagramm  %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Uebertragungsfunktionen = calc_Uebertragungsfunktion(Fall,Zustandsraum,Verzeichnis,AlleFlugzeuge,prefix)

%% Übertragungsfunktion bestimmen
Uebertragungsfunktionen = tf(Zustandsraum);

if AlleFlugzeuge~=2
    % Grafische Darstellung der Pol-Nullstellen-Verteilung
    disp(' ');
    disp('Sollen die Bodediagramme grafisch dargestellt werden?');
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
% Funktion beenden
if auxAuswahl == 2
    return;
end

% Längsbewegung
if Fall == 1
    Bode_LB(Uebertragungsfunktionen,Verzeichnis,prefix);
    % Seitenbewegung
else
    Bode_SB(Uebertragungsfunktionen,Verzeichnis,prefix);
end

if AlleFlugzeuge~=2
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

function Bode_LB(UE,Verzeichnis,prefix)
for state=1:4
    for input=1:2
        if (length(UE(state,input).num{1}) > 1)
            Bode(UE(state,input),UE.OutputName{state},UE.InputName{input},Verzeichnis,UE.Name,prefix);
        end
    end
end

end

function Bode_SB(UE,Verzeichnis,prefix)
for state=1:4
    for input=1:2
        if (length(UE(state,input).num{1}) > 1)
            Bode(UE(state,input),UE.OutputName{state},UE.InputName{input},Verzeichnis,UE.Name,prefix);
        end
    end
end
end

function Bode(UE,state,input,Verzeichnis,Bewegung,prefix)
% Definition des Eingangsfrequenzbereichs
o1 = 10^(-3):10^(-4):(10^(-2)-10^(-4));
o2 = 10^(-2):10^(-3):(10^(-1)-10^(-3));
o3 = 10^(-1):10^(-2):(10^(0)-10^(-2));
o4 = 10^(0):10^(-1):(10^(1)-10^(-1));
o5 = 10^(1):10^(0):(10^(2));
ome = [o1,o2,o3,o4,o5];

%Amplitude und Phase des Frequenzganges berechnen
[Amp,Pha] = bode(UE,ome);

%Ermitteln der Verstärkung
aux1 = zpk(UE);
K = aux1.k;

h = figure('Name',(['Bodediagramm der Übertragungsfunktion ',input,' auf ',state]),'units','normalized','outerposition',[0 0 1 1]);
% Erstellen eines Plots mit zwei Zeilen und einer Spalte
subplot(2,1,1);

% Bestimmen der Amplitude
% für Ausgabe: Umrechnen in deg
if (strcmp(UE.InputUnit,'deg') || strcmp(UE.InputUnit,'deg/s')) && (strcmp(UE.OutputUnit,'deg') || strcmp(UE.OutputUnit,'deg/s'))
    conv=1;
elseif (strcmp(UE.InputUnit,'deg') || strcmp(UE.InputUnit,'deg/s')) && ~(strcmp(UE.OutputUnit,'deg') || strcmp(UE.OutputUnit,'deg/s'))
    conv=pi/180;
elseif ~(strcmp(UE.InputUnit,'deg') || strcmp(UE.InputUnit,'deg/s')) && (strcmp(UE.OutputUnit,'deg') || strcmp(UE.OutputUnit,'deg/s'))
    conv=180/pi;
else
    conv=1;
end
Amp = 20*log10(Amp(1,:)'.*conv);

semilogx(ome,Amp,'LineWidth',2.5);
ylabel('{\bf A} [dB]', 'FontSize', 14);
Anz = length(Amp);

% Anpassung der Skalierung
pmax = 0;
pmin = 0;

for z = 1:Anz
    if Amp(z) > pmax
        pmax = Amp(z);
    end
    if Amp(z) < pmin
        pmin = Amp(z);
    end
end

max = floor(pmax/20);
min = ceil(pmin/20);
Ticks = (min*20-20):20:(max*20+20);
set(gca, 'YTickMode', 'manual', 'YTick', Ticks,'FontSize', 14, 'XTickLabel',[], 'xlim', [(10^(-3)) (10^(2))], 'ylim', [(min*20-20) (max*20+20)]);
grid on;
title([prefix,' - ',Bewegung,': Bodediagramm der Übertragungsfunktion ',input,' auf ',state,' in [',char(UE.OutputUnit),' / ',char(UE.InputUnit),']'], 'FontSize', 14);

subplot(2,1,2);
% Bestimmen der Phase
Pha = Pha(1,:)';
aa = round(Pha(1)/360);
Pha = Pha - aa*360;

% Bestimmen der Anfangsphase
if (K<0) && (Pha(1) > 90)
    Pha = Pha - 360;
elseif (K>0) && (Pha(1) < -90)
    Pha = Pha + 360;
end

semilogx(ome,Pha,'LineWidth',2.5);
xlabel('{\bf \omega} [rad/s]', 'FontSize', 14);
ylabel('{\bf \phi} [^\circ]', 'FontSize', 14);
grid on;
Anz = length(Pha);

% Skalierung
pmax = 0;
pmin = 0;

for z = 1:Anz
    if Pha(z) > pmax
        pmax = Pha(z);
    end
    if Pha(z) < pmin
        pmin = Pha(z);
    end
end

max = floor(pmax/90);
min = ceil(pmin/90);

Ticks = (min*90-90):90:(max*90+90);
set(gca, 'YTickMode', 'manual', 'YTick', Ticks, 'FontSize', 14, 'xlim', [(10^(-3)) (10^(2))]);

if strcmp(state(1),'\')
    state = state(2:length(state));
end

%Ausgabe des Bodediagramms in pdf-Datei 
if strcmp(input(1),'\')
    input = input(2:length(input));
end
if (exist([Verzeichnis,'\Grafiken'],'dir') == 0)
    mkdir([Verzeichnis,'\Grafiken']);
end
orient landscape
print(h,'-dpdf','-r300',[Verzeichnis,'\Grafiken\',prefix,' - Bodediagramm der ÜF ',input,' auf ',state]);

end


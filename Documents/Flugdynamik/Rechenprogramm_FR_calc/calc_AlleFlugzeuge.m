%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% Technische Universität Berlin - Fakultät V                              %
% Institut für Luft- und Raumfahrttechnik                                 %
% Fachgebiet Flugmechanik, Flugregelung und Aeroelastizität               %
% Prof. Dr.-Ing. Robert Luckner                                           %
%                                                                         %
% Projektname:      FR_calc - Berechnungstool für das Buch Flugregelung   %
% Datei:            calc_lleFlugzeuge.m                                   %
% Zweck:            Berechnungsprogramm für alle Flugzeuge                %
%                                                                         %
% Autoren:          Prof. Dr.-Ing. Robert Luckner                         %  
%                   Dipl.-Ing. Andrej Schönfeld                           %
%                   Alexander Köthe, B.Sc.                                %
%                   cand.-Ing. Fadi Bitar                                 %
%                                                                         %
% Version :         1.0                                                  %
% Datum   :         28.10.2011                                            %
%                                                                         %
%_________________________________________________________________________%
%                                                                         %
% Revisionen                                                              %
% ----------                                                              %
% Nr.  Datum     Autor          Änderung                                  %
% ---  --------  -------------  ---------------------------------------   %
%   1  04.09.11  Köthe          Version 1.0                               %
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
% Ausgangsgrößen:  Error         - Fehlercode                             %
%                  mat-Dateien   - Ergebnisstrukturen                     %
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

function Error = calc_AlleFlugzeuge(AlleFlugzeuge)

% Laden der Derivative
get_Derivative;

for auxAuswahl = 1:5
    clc;
    a=['Flugzeugtyp : ',AC(auxAuswahl).Name];
    disp(a);
    disp(' ');
    % Erstellen eines Ordners mit dem Namen des Flugzeugs falls noch nicht
    % vorhanden
    if (exist(AC(auxAuswahl).Name,'dir') == 0)
        mkdir(AC(auxAuswahl).Name);
    end

    Verzeichnis = AC(auxAuswahl).Name;
    for auxBewegungsform = 1:2
        if auxBewegungsform == 1
            disp('1 - Längsbewegung');
        else
            disp('2 - Seitenbewegung');
        end
        disp(' ');
        
        for auxFlugzustand = 1:3
            a = [FZ(3*(auxAuswahl-1)+auxFlugzustand).Bezeichnung];
            disp(a);
            disp(' ');
            %Praefix für Fall und Bewegungsform bestimmen
            prefix=[AC(auxAuswahl).Name,' - ',FZ(3*(auxAuswahl-1)+auxFlugzustand).Kuerzel];
            
            % Ersatzgroessen-----------------------------------------------
            % Berechnen der Ersatzgroessen
            EZ = calc_Ersatzgroessen(auxBewegungsform,AC(auxAuswahl),FZ(3*(auxAuswahl-1)+auxFlugzustand));
            if (auxBewegungsform == 1)
                EZLB((auxAuswahl-1)*3+auxFlugzustand) = EZ;
            else
                EZSB((auxAuswahl-1)*3+auxFlugzustand) = EZ;
            end    
            disp('Ersatzgroessen erfolgreich berechnet');

            % Speichern der Ersatzgroessen
            if auxBewegungsform == 1
                a = [AC(auxAuswahl).Name,'\',FZ(3*(auxAuswahl-1)+auxFlugzustand).Kuerzel,'_LB_Ersatzgroessen.mat'];
            else
                a = [AC(auxAuswahl).Name,'\',FZ(3*(auxAuswahl-1)+auxFlugzustand).Kuerzel,'_SB_Ersatzgroessen.mat'];
            end
            save(a,'EZ');
            disp('Ersatzgroessen erfolgreich gespeichert');
            
            % Zustandsraum-------------------------------------------------
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
            
            % Übertragungsfunktionen---------------------------------------
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
            
            % Eigenwerte, Eigenvektoren und Pol-Nullstellen-Darstellung----
            % Bestimmen von Eigenwerten, Eigenvektoren und Pol-Nullstellen-Darstellung
            disp(' ');
            disp('Eigenwerte, Eigenvektoren und Pol- Nullstellen Darstellung');
            disp('----------------------------------------------------------');
            
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
            disp(' ');
            
            % Sprungantworten----------------------------------------------
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
            disp('Sprungantworten erfolgreich gespeichert');
            
            % Wurzelortskurven---------------------------------------------
            disp(' ');
            disp('Wurzelortskurven');
            disp('----------------');
            disp(' ');
            calc_WOK(ZR,Verzeichnis,AlleFlugzeuge,prefix);
            disp(' ');
            disp('-------------------------------------------------------');
        end
        disp('-------------------------------------------------------');
    end
    clc;
end
Error = Erstelle_Tex(EZLB,EZSB);
end

function Error = Erstelle_Tex(EZLB,EZSB)
Datei = fopen('Ersatzgroessen.tex','wt');
a='\documentclass[12pt,a4paper,landscape] {article}';
fprintf(Datei,'%s\n',a);
a='\usepackage[a4paper,hmargin={2.5cm,2.5cm}, vscale=.75]{geometry}';
fprintf(Datei,'%s\n',a);
a='\usepackage[ngerman]{babel}';
fprintf(Datei,'%s\n',a);
a='\usepackage{paralist}';
fprintf(Datei,'%s\n',a);
a='\usepackage[latin1]{inputenc}';
fprintf(Datei,'%s\n',a);
a='\usepackage{lscape}';
fprintf(Datei,'%s\n',a);
a='\usepackage{url}';
fprintf(Datei,'%s\n',a);
a='\usepackage{cite}';
fprintf(Datei,'%s\n',a);
a='\usepackage{paralist}';
fprintf(Datei,'%s\n',a);
a='\usepackage{booktabs}';
fprintf(Datei,'%s\n',a);
a='\usepackage{array}';
fprintf(Datei,'%s\n',a);
a='\usepackage{tabularx}';
fprintf(Datei,'%s\n',a);
a='\usepackage{dcolumn}';
fprintf(Datei,'%s\n',a);
a='\usepackage{graphicx}';
fprintf(Datei,'%s\n',a);
a='\usepackage{fancyhdr}';
fprintf(Datei,'%s\n',a);
a='\setlength{\parindent}{0.0cm}';
fprintf(Datei,'%s\n',a);
a='\begin{document}';
fprintf(Datei,'%s\n',a);
a='\huge{Ersatzgr\"o\ss en der L\"angsbewegung}';
fprintf(Datei,'%s\n',a);
a=' ';
fprintf(Datei,'%s\n',a);
a='\bigskip';
fprintf(Datei,'%s\n',a);
a='\begin{small}';
fprintf(Datei,'%s\n',a);
a='\begin{center}';
fprintf(Datei,'%s\n',a);
a='\begin{tabular}{c|c|c|c|c|c|c|c|c|c|c|c|c|c|c|c}';
fprintf(Datei,'%s\n',a);
a=' & A1 & A2 & A3 & B1 & B2 & B3 & C1 & C2 & C3 & D1 & D2 & D3 & F1 & F2 & F3 \\';
fprintf(Datei,'%s\n',a);
a='\hline';
fprintf(Datei,'%s\n',a);

%Xu
a=['$\mathrm{X}_{\mathrm{u}}$ & '];
for i=1:14
    a =[a,num2str(EZLB(i).Xu,'%5.4f'), ' & '];
end
a=[a,num2str(EZLB(15).Xu,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

%Xal
a=['$\mathrm{X}_{\alpha}$ & '];
for i=1:14
    a =[a,num2str(EZLB(i).Xal,'%5.4f'), ' & '];
end
a=[a,num2str(EZLB(15).Xal,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

%Xalp
a=['$\mathrm{X}_{\dot{\alpha}}$ & '];
for i=1:14
    a =[a,num2str(EZLB(i).Xalp,'%5.4f'), ' & '];
end
a=[a,num2str(EZLB(15).Xalp,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

%Xq
a=['$\mathrm{X}_{\mathrm{q}}$ & '];
for i=1:14
    a =[a,num2str(EZLB(i).Xq,'%5.4f'), ' & '];
end
a=[a,num2str(EZLB(15).Xq,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

% Xthe
a=['$\mathrm{X}_{\Theta}$ & '];
for i=1:14
    a =[a,num2str(EZLB(i).Xthe,'%5.4f'), ' & '];
end
a=[a,num2str(EZLB(15).Xthe,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

%Xeta
a=['$\mathrm{X}_{\eta}$ & '];
for i=1:14
    a =[a,num2str(EZLB(i).Xeta,'%5.4f'), ' & '];
end
a=[a,num2str(EZLB(15).Xeta,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

%Xf
a=['$\mathrm{X}_{\mathrm{f}}$ & '];
for i=1:14
    a =[a,num2str(EZLB(i).Xf,'%5.4f'), ' & '];
end
a=[a,num2str(EZLB(15).Xf,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

%Xkap
a=['$\mathrm{X}_{\kappa}$ & '];
for i=1:14
    a =[a,num2str(EZLB(i).Xkap,'%5.4f'), ' & '];
end
a=[a,num2str(EZLB(15).Xkap,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

%Zu
a=['$\mathrm{Z}_{\mathrm{u}}$ & '];
for i=1:14
    a =[a,num2str(EZLB(i).Zu,'%5.4f'), ' & '];
end
a=[a,num2str(EZLB(15).Zu,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

%Zal
a=['$\mathrm{Z}_{\alpha}$ & '];
for i=1:14
    a =[a,num2str(EZLB(i).Zal,'%5.4f'), ' & '];
end
a=[a,num2str(EZLB(15).Zal,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

%Zalp
a=['$\mathrm{Z}_{\dot{\alpha}}$ & '];
for i=1:14
    a =[a,num2str(EZLB(i).Zalp,'%5.4f'), ' & '];
end
a=[a,num2str(EZLB(15).Zalp,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

%Zq
a=['$\mathrm{Z}_{\mathrm{q}}$ & '];
for i=1:14
    a =[a,num2str(EZLB(i).Zq,'%5.4f'), ' & '];
end
a=[a,num2str(EZLB(15).Zq,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

%Zthe
a=['$\mathrm{Z}_{\Theta}$ & '];
for i=1:14
    a =[a,num2str(EZLB(i).Zthe,'%5.4f'), ' & '];
end
a=[a,num2str(EZLB(15).Zthe,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

%Zeta
a=['$\mathrm{Z}_{\eta}$ & '];
for i=1:14
    a =[a,num2str(EZLB(i).Zeta,'%5.4f'), ' & '];
end
a=[a,num2str(EZLB(15).Zeta,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

%Zf
a=['$\mathrm{Z}_{\mathrm{f}}$ & '];
for i=1:14
    a =[a,num2str(EZLB(i).Zf,'%5.4f'), ' & '];
end
a=[a,num2str(EZLB(15).Zf,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

%Zkap
a=['$\mathrm{Z}_{\kappa}$ & '];
for i=1:14
    a =[a,num2str(EZLB(i).Zkap,'%5.4f'), ' & '];
end
a=[a,num2str(EZLB(15).Zkap,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

%Mu
a=['$\mathrm{M}_{\mathrm{u}}$ & '];
for i=1:14
    a =[a,num2str(EZLB(i).Mu,'%5.4f'), ' & '];
end
a=[a,num2str(EZLB(15).Mu,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

%Mal
a=['$\mathrm{M}_{\alpha}$ & '];
for i=1:14
    a =[a,num2str(EZLB(i).Mal,'%5.4f'), ' & '];
end
a=[a,num2str(EZLB(15).Mal,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

%Malp
a=['$\mathrm{M}_{\dot{\alpha}}$ & '];
for i=1:14
    a =[a,num2str(EZLB(i).Malp,'%5.4f'), ' & '];
end
a=[a,num2str(EZLB(15).Malp,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

%Mq
a=['$\mathrm{M}_{\mathrm{q}}$ & '];
for i=1:14
    a =[a,num2str(EZLB(i).Mq,'%5.4f'), ' & '];
end
a=[a,num2str(EZLB(15).Mq,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

%Meta
a=['$\mathrm{M}_{\eta}$ & '];
for i=1:14
    a =[a,num2str(EZLB(i).Meta,'%5.4f'), ' & '];
end
a=[a,num2str(EZLB(15).Meta,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

%Mf
a=['$\mathrm{M}_{\mathrm{f}}$ & '];
for i=1:14
    a =[a,num2str(EZLB(i).Mf,'%5.4f'), ' & '];
end
a=[a,num2str(EZLB(15).Mf,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

%Mkap
a=['$\mathrm{M}_{\kappa}$ & '];
for i=1:14
    a =[a,num2str(EZLB(i).Mkap,'%5.4f'), ' & '];
end
a=[a,num2str(EZLB(15).Mkap,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

%MWx
a=['$\mathrm{M}_{\mathrm{Wx}}$ & '];
for i=1:14
    a =[a,num2str(EZLB(i).MWx,'%5.4f'), ' & '];
end
a=[a,num2str(EZLB(15).MWx,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a='\end{tabular}';
fprintf(Datei,'%s\n',a);
a='\end{center}';
fprintf(Datei,'%s\n',a);
a='\end{small}';
fprintf(Datei,'%s\n',a);
a='\newpage';
fprintf(Datei,'%s\n',a);

a='\huge{Ersatzgr\"o\ss en der Seitenbewegung}';
fprintf(Datei,'%s\n',a);
a=' ';
fprintf(Datei,'%s\n',a);
a='\bigskip';
fprintf(Datei,'%s\n',a);
a='\begin{small}';
fprintf(Datei,'%s\n',a);
a='\begin{center}';
fprintf(Datei,'%s\n',a);
a='\begin{tabular}{c|c|c|c|c|c|c|c|c|c|c|c|c|c|c|c}';
fprintf(Datei,'%s\n',a);
a=' & A1 & A2 & A3 & B1 & B2 & B3 & C1 & C2 & C3 & D1 & D2 & D3 & F1 & F2 & F3 \\';
fprintf(Datei,'%s\n',a);
a='\hline';
fprintf(Datei,'%s\n',a);

%Ybet
a=['$\mathrm{Y}_{\beta}$ & '];
for i=1:14
    a =[a,num2str(EZSB(i).Ybet,'%5.4f'), ' & '];
end
a=[a,num2str(EZSB(15).Ybet,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

%Ybetp
a=['$\mathrm{Y}_{\dot{\beta}}$ & '];
for i=1:14
    a =[a,num2str(EZSB(i).Ybetp,'%5.4f'), ' & '];
end
a=[a,num2str(EZSB(15).Ybetp,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

%Yp
a=['$\mathrm{Y}_{\mathrm{p}}$ & '];
for i=1:14
    a =[a,num2str(EZSB(i).Yp,'%5.4f'), ' & '];
end
a=[a,num2str(EZSB(15).Yp,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

%Yr
a=['$\mathrm{Y}_{\mathrm{r}}$ & '];
for i=1:14
    a =[a,num2str(EZSB(i).Yr,'%5.4f'), ' & '];
end
a=[a,num2str(EZSB(15).Yr,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

% Yxi
a=['$\mathrm{Y}_{\xi}$ & '];
for i=1:14
    a =[a,num2str(EZSB(i).Yxi,'%5.4f'), ' & '];
end
a=[a,num2str(EZSB(15).Yxi,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

%Yzeta
a=['$\mathrm{Y}_{\zeta}$ & '];
for i=1:14
    a =[a,num2str(EZSB(i).Yzeta,'%5.4f'), ' & '];
end
a=[a,num2str(EZSB(15).Yzeta,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

%Lbet
a=['$\mathrm{L}_{\beta}$ & '];
for i=1:14
    a =[a,num2str(EZSB(i).Lbet,'%5.4f'), ' & '];
end
a=[a,num2str(EZSB(15).Lbet,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

%Lbetp
a=['$\mathrm{L}_{\dot{\beta}}$ & '];
for i=1:14
    a =[a,num2str(EZSB(i).Lbetp,'%5.4f'), ' & '];
end
a=[a,num2str(EZSB(15).Lbetp,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

%Lp
a=['$\mathrm{L}_{\mathrm{p}}$ & '];
for i=1:14
    a =[a,num2str(EZSB(i).Lp,'%5.4f'), ' & '];
end
a=[a,num2str(EZSB(15).Lp,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

%Lr
a=['$\mathrm{L}_{\mathrm{r}}$ & '];
for i=1:14
    a =[a,num2str(EZSB(i).Lr,'%5.4f'), ' & '];
end
a=[a,num2str(EZSB(15).Lr,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

%Lxi
a=['$\mathrm{L}_{\xi}$ & '];
for i=1:14
    a =[a,num2str(EZSB(i).Lxi,'%5.4f'), ' & '];
end
a=[a,num2str(EZSB(15).Lxi,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

%Lzeta
a=['$\mathrm{L}_{\zeta}$ & '];
for i=1:14
    a =[a,num2str(EZSB(i).Lzeta,'%5.4f'), ' & '];
end
a=[a,num2str(EZSB(15).Lzeta,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

%Nbet
a=['$\mathrm{N}_{\beta}$ & '];
for i=1:14
    a =[a,num2str(EZSB(i).Nbet,'%5.4f'), ' & '];
end
a=[a,num2str(EZSB(15).Nbet,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

%Nbetp
a=['$\mathrm{N}_{\dot{\beta}}$ & '];
for i=1:14
    a =[a,num2str(EZSB(i).Nbetp,'%5.4f'), ' & '];
end
a=[a,num2str(EZSB(15).Nbetp,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

%Np
a=['$\mathrm{N}_{\mathrm{p}}$ & '];
for i=1:14
    a =[a,num2str(EZSB(i).Np,'%5.4f'), ' & '];
end
a=[a,num2str(EZSB(15).Np,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

%Nr
a=['$\mathrm{N}_{\mathrm{r}}$ & '];
for i=1:14
    a =[a,num2str(EZSB(i).Nr,'%5.4f'), ' & '];
end
a=[a,num2str(EZSB(15).Nr,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

%Nxi
a=['$\mathrm{N}_{\xi}$ & '];
for i=1:14
    a =[a,num2str(EZSB(i).Nxi,'%5.4f'), ' & '];
end
a=[a,num2str(EZSB(15).Nxi,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

%Nzeta
a=['$\mathrm{N}_{\zeta}$ & '];
for i=1:14
    a =[a,num2str(EZSB(i).Nzeta,'%5.4f'), ' & '];
end
a=[a,num2str(EZSB(15).Nzeta,'%5.4f'), '\\'];
fprintf(Datei,'%s\n',a);
a=['\hline'];
fprintf(Datei,'%s\n',a);

a='\end{tabular}';
fprintf(Datei,'%s\n',a);
a='\end{center}';
fprintf(Datei,'%s\n',a);
a='\end{small}';
fprintf(Datei,'%s\n',a);
a='\end{document}';
fprintf(Datei,'%s\n',a);
fclose(Datei);
Error = 0;
end
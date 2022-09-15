%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% Technische Universit�t Berlin - Fakult�t V                              %
% Institut f�r Luft- und Raumfahrttechnik                                 %
% Fachgebiet Flugmechanik, Flugregelung und Aeroelastizit�t               %
% Prof. Dr.-Ing. Robert Luckner                                           %
%                                                                         %
% Projektname:      FR_calc - Berechnungstool f�r das Buch Flugregelung   %
% Datei:            FR_calc.m                                             %
% Zweck:            Hauptprogramm                                         %
%                                                                         %
% Autoren:          Prof. Dr.-Ing. Robert Luckner                         %  
%                   Dipl.-Ing. Andrej Sch�nfeld                           %
%                   Alexander K�the, B.Sc.                                %
%                   cand.-Ing. Fadi Bitar                                 %
%                                                                         %
% Version :         1.0                                                   %
% Datum   :         28.10.2011                                            %
%                                                                         %
%_________________________________________________________________________%
%                                                                         %
% Revisionen                                                              %
% ----------                                                              %
% Nr.  Datum     Autor          �nderung                                  %
% ---  --------  -------------  ---------------------------------------   %
%                                                                         %
%_________________________________________________________________________%
%                                                                         %
% Alle Daten in SI-Einheiten, Winkel werden in Grad ein- und ausgegeben,  %
% m�ssen aber programmintern in das Bogenma� umgerechnet werden           %
%                                                                         %
% externe Variable                                                        %
% ----------------                                                        %
% Eingangsgr��en:  keine                                                  %
% Ausgabgsgr��en:  Error         - Fehlercode                             %
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
% EZ            ---                   Ersatzgr��en (Struktur)             %
% EZLB          ---                   Ersatzgr��en der L�ngsbewegung      %
%                                     (Struktur)                          %
% EZSB          ---                   Ersatzgr��en der Seitenbewegung     %
%                                     (Struktur)                          %
% ZR            ---                   Zustandsraum (Struktur)             %
% UF            ---                   �bertragungsfunktionen (Struktur)   %
% Eigenver-     ---                   Struktur mit Eigenvektoren und      %
% verhalten                           Eigenwerten                         %
% EV            ---                   Eigenvektor                         %
% EW            ---                   Eigenwert                           %
% SAW           ---                   Sprungantworten (Struktur)          %
% i             ---                   Z�hlschleife                        %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Beginn Hauptprogramm

function Error = FR_calc()
% Speicher und Workspace leeren
clear all;
clc;

% ErrorVariable
% 1 - Fehler, 0 - kein Fehler
Error = 1;

disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp('%                                                                       %');
disp('% Technische Universit�t Berlin - Fakult�t V                            %');
disp('% Institut f�r Luft- und Raumfahrttechnik                               %');
disp('% Fachgebiet Flugmechanik, Flugregelung und Aeroelastizit�t             %');
disp('% Prof. Dr.-Ing. Robert Luckner                                         %');
disp('%                                                                       %');
disp('% Rechenprogramm FR_calc zur Berechnung von Ersatzgr��en, Zustands-     %');
disp('% raumdarstellung, Eigenwerte, Frequenzg�nge, Wurzelortskurven und      %');
disp('% Zeitantworten f�r die im Buch Flugregelung (Anhang) gegebenen Daten   %');
disp('% --------------------------------------------------------------------  %');
disp('%                                                                       %');
disp('% Autoren:          Prof. Dr.-Ing. Robert Luckner                       %');
disp('%                   Dipl.-Ing. Andrej Sch�nfeld                         %');
disp('%                   Alexander K�the, B.Sc.                              %');
disp('%                   cand.-Ing. Fadi Bitar                               %');
disp('%                                                                       %');
disp('% Version :         1.0                                                 %');
disp('%                                                                       %');
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp(' ');
disp(' ');

Error0 = 0;
while (Error0 == 0)
    Error0 = Hauptmenue();
    disp(' ');
end
end


function Error = Hauptmenue()
    disp('Hauptmen�');
    disp('---------');
    disp(' ');
    disp(' 1 - Ein Flugzeug berechnen');
    disp(' 2 - Alle Flugzeuge berechnen');
    disp(' 3 - Programm beenden');
    disp(' ')
    
    % Auswahl des Hauptemn�s
    
    Error2 = 1;
    while (Error2 == 1)
        Auswahl = input('Bitte treffen Sie Ihre Auswahl : ','s');
        Error2 = Hauptauswahl(Auswahl);
        if (Error2 ~= 1)
            auxAuswahl = str2double(Auswahl);
        end
    end
    
    if (auxAuswahl == 3)
        % Beenden des Programms
        Error = -1;
        return;
    end
    
    % Ein Flugzeug
    if (auxAuswahl == 1)
        Error = select_Flugzeug(auxAuswahl);
    end
    
    if (auxAuswahl == 2)
        Error = calc_AlleFlugzeuge(auxAuswahl);
    end
    
end

function Error = Hauptauswahl(Auswahl)

if (strcmp(Auswahl,'1') || strcmp(Auswahl,'2') || strcmp(Auswahl,'3'))
    Error = 0;
else
    disp(' ');
    disp('Ihre Eingabe konnte nicht zugeordnet werden. Bitte wiederholen Sie Ihre Eingabe!');
    disp('[1]  : Ein Flugzeug berechnen');
    disp('[2]  : Alle Flugzeuge berechnen');
    disp('[3]  : Programmende');
    disp(' ');
    Error = 1;
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% Technische Universität Berlin - Fakultät V                              %
% Institut für Luft- und Raumfahrttechnik                                 %
% Fachgebiet Flugmechanik, Flugregelung und Aeroelastizität               %
% Prof. Dr.-Ing. Robert Luckner                                           %
%                                                                         %
% Projektname:      FR_calc - Berechnungstool für das Buch Flugregelung   %
% Datei:            calc_Eigenwerte.m                                     %
% Zweck:            Berechnung der Eigenwerte und Eigenvektoren           %
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
% Eingangsgrößen:  Fall          - Bewegungsform; 1 = LB; 2 = SB          %
%                  UE            - Übertragungsfunktionen                 %
%                  Zustandsraum  - Flugzstandsparameter                   %
%                  Verzeichnis   -                                        %
%                  AlleFlugzeuge - Auswahl                                %
%                                  (1 - ein Flugzeug; 2 - alle Flugzeuge) %
%                  prefix        - Praefix für Fall und Bewegungsform     %
% Ausgangsgrößen:  Eigenvektoren - Eigenvektoren                          %
%                  Eigenwerte    - Eigenwerte                             %
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
% auxEigenwerte ---                   Hilfsvektor mit den Eigenwerten     %
% Pol           p                     Pole                                %
% Zeros         n                     Nullstellen                         %
% Zustaende     ---                   Bezeichnung der Zustandsgrößen      %
% Steuergroes-  ---                   Bezeichnung der Steuergrößen        %
% sen                                                                     %
%         ---                   Zählvariable über die Zustände      %
% maxRe         ---                   maximaler Realanteil                %
% minRe         ---                   minimaler Realanteil                %
% maxIm         ---                   maximaler Imaginäranteil            %
% minIm         ---                   minimaler Imaginäranteil            %
% aux           ---                   Hilfsvariable                       %
% deltaRe       ---                   Abstand zwischen maximalen und      %
%               ---                   minimalen Realteil                  %
% deltaIm       ---                   Abstand zwischen maximalen und      %
%               ---                   minimalen Imaginärteil              %
% diff          ---                   Hilfsvariable : Differenz           %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Eigenvektoren,Eigenwerte] = calc_Eigenwerte(Fall,UE,Zustandsraum,Verzeichnis,AlleFlugzeuge,prefix)

% Eigenwerte und Eigenvektoren bestimmen
[Eigenvektoren,auxEigenwerte] = eig(Zustandsraum.A);

if AlleFlugzeuge~=2
    % Grafische Darstellung der Pol-Nullstellen-Verteilung
    disp(' ');
    disp('Soll die Pol-Nullstellen-Verteilung grafisch dargestellt werden?');
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

% Auslesen der Eigenwerte
Eigenwerte = zeros(1, 4);
for i=1:4
    Eigenwerte(i) = auxEigenwerte(i,i);
end

% Funktion beenden
if auxAuswahl == 2
    return;
end

if Fall == 1
    % Längsbewegung
    Pol_Nullstellen_LB(UE,Verzeichnis,AlleFlugzeuge,prefix);
else
    % Seitenbewegung
    Pol_Nullstellen_SB(UE,Verzeichnis,AlleFlugzeuge,prefix);
end

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

function Pol_Nullstellen_LB(UE,Verzeichnis,AlleFlugzeuge,prefix)

Zustaende = {'q','\alpha','V','\gamma'};
Steuergroessen = {'f','\eta'};

for states=1:4
    h = figure('Name',['Pol-Nullstellen-Darstellung des Zustands ',Zustaende{states}], 'units','normalized','outerposition',[0 0 1 1]);
    for input=1:2
        h1= subplot(1,2,input);
        
        % Positionen aus der Pole und Nullstellen aus der pzmap
        [Pol,Zeros]=pzmap(UE(states,input));
        
        % Prüfen, ob Pole vorhanden sind
        % Pole vorhanden
        if (length(Pol) > 0)
            
            % Plotten der Pole und Nullstellen
            plot(real(Pol),imag(Pol),'X',real(Zeros),imag(Zeros),'O','Linewidth',2.5,'MarkerSize',15);
            hold on;
            
            % Gleiche Achsenskalierung
            maxRe = 0;
            minRe = 0;
            minIm = 0;
            maxIm = 0;
            
            % Prüfen nach und kleinsten Real- und Imaginärteil der Pole
            for i=1:(length(Pol))
                aux = real(Pol(i));
                if aux > maxRe
                    maxRe = aux;
                end
                if aux < minRe
                    minRe = aux;
                end
                aux = imag(Pol(i));
                if aux > maxIm
                    maxIm = aux;
                end
                if aux < minIm
                    minIm = aux;
                end
            end
            
            % Prüfen nach und kleinsten Real- und Imaginärteil der
            % Nullstellen
            for i=1:(length(Zeros))
                aux = real(Zeros(i));
                if aux > maxRe
                    maxRe = aux;
                end
                if aux < minRe
                    minRe = aux;
                end
                aux = imag(Zeros(i));
                if aux > maxIm
                    maxIm = aux;
                end
                if aux < minIm
                    minIm = aux;
                end
            end
            deltaRe = abs(maxRe) + abs(minRe);
            deltaIm = abs(maxIm) + abs(minIm);
            
            if deltaRe > deltaIm
                diff = (deltaRe-deltaIm)/2;
                maxIm = maxIm + diff;
                minIm = minIm - diff;
            elseif deltaIm > deltaRe
                diff = (deltaIm-deltaRe)/2;
                maxRe = maxRe + diff;
                minRe = minRe - diff;
            end
            % Skalierung der Achsen
            maxIm = 1.2 * maxIm;
            minIm = 1.2 * minIm;
            maxRe = 1.2 * maxRe;
            minRe = 1.2 * minRe;
        else
            % Keine Pole vorhanden
            text(-.55,.6,'Keine Werte','FontSize',14,'HorizontalAlignment','center');
            maxIm = 1;
            maxRe = 1;
            minIm = -1;
            minRe = -1;
        end
        
        % Titel hinzufügen
        state = Zustaende{states};
        title([prefix,' - Längsbewegung: ',Steuergroessen{input},' auf ',state]);
        
        % Achsbeschriftung
        xlabel('{\bf \sigma} [rad/s]','Fontsize',12.0)
        ylabel('{\bf j\omega} [rad/s]','Fontsize',12.0)
        
        % Schriftgröße
        set(h1, 'FontSize',12.0);
        hold on;
        
        % Koordinatenachsen plotten
        plot([minRe maxRe],[0 0],'k','Linewidth',2);
        hold on;
        plot([0 0],[minIm maxIm],'k','Linewidth',2);
        grid on;
        axis equal
        set(h1, 'xlim',[minRe maxRe],'ylim',[minIm maxIm]);
    end
    
    if (exist([Verzeichnis,'\Grafiken'],'dir') == 0)
        mkdir([Verzeichnis,'\Grafiken']);
    end
    
    orient landscape
    if strcmp(state(1),'\')
        print(h,'-dpdf','-r300',[Verzeichnis,'\Grafiken\',prefix,' - Pol-Nullstellen - Steuergroessen auf ',state(2:length(state))]);
    else
        print(h,'-dpdf','-r300',[Verzeichnis,'\Grafiken\',prefix,' - Pol-Nullstellen - Steuergroessen auf ',state]);
    end
    
end

if AlleFlugzeuge~=2
    disp('Bitte mit beliebiger Taste fortsetzen...');
    pause;
end
close all
end

function Pol_Nullstellen_SB(UE,Verzeichnis,AlleFlugzeuge,prefix)
Zustaende = {'r','\beta','p','\Phi'};
Steuergroessen = {'\xi','\zeta'};

for states=1:4
    h = figure('Name',['Pol-Nullstellen-Darstellung des Zustands ',Zustaende{states}], 'units','normalized','outerposition',[0 0 1 1]);
    for input=1:2
        h1= subplot(1,2,input);
        
        % Positionen aus der Pole und Nullstellen aus der pzmap
        [Pol,Zeros]=pzmap(UE(states,input));
        
        % Prüfen, ob Pole vorhanden sind
        % Pole vorhanden
        if (length(Pol) > 0)
            
            % Plotten der Pole und Nullstellen
            plot(real(Pol),imag(Pol),'X',real(Zeros),imag(Zeros),'O','Linewidth',2.5,'MarkerSize',15);
            hold on;
            
            % Gleiche Achsenskalierung
            maxRe = 0;
            minRe = 0;
            minIm = 0;
            maxIm = 0;
            
            % Prüfen nach und kleinsten Real- und Imaginärteil der Pole
            for i=1:(length(Pol))
                aux = real(Pol(i));
                if aux > maxRe
                    maxRe = aux;
                end
                if aux < minRe
                    minRe = aux;
                end
                aux = imag(Pol(i));
                if aux > maxIm
                    maxIm = aux;
                end
                if aux < minIm
                    minIm = aux;
                end
            end
            
            % Prüfen nach und kleinsten Real- und Imaginärteil der
            % Nullstellen
            for i=1:(length(Zeros))
                aux = real(Zeros(i));
                if aux > maxRe
                    maxRe = aux;
                end
                if aux < minRe
                    minRe = aux;
                end
                aux = imag(Zeros(i));
                if aux > maxIm
                    maxIm = aux;
                end
                if aux < minIm
                    minIm = aux;
                end
                
            end
            deltaRe = abs(maxRe) + abs(minRe);
            deltaIm = abs(maxIm) + abs(minIm);
            
            if deltaRe > deltaIm
                diff = (deltaRe-deltaIm)/2;
                maxIm = maxIm + diff;
                minIm = minIm - diff;
            elseif deltaIm > deltaRe
                diff = (deltaIm-deltaRe)/2;
                maxRe = maxRe + diff;
                minRe = minRe - diff;
            end
            % Skalierung der Achsen
            maxIm = 1.2 * maxIm;
            minIm = 1.2 * minIm;
            maxRe = 1.2 * maxRe;
            minRe = 1.2 * minRe;
            
        else            
            % Keine Pole vorhanden
            text(-.55,.6,'Keine Werte','FontSize',14,'HorizontalAlignment','center');
            maxIm = 1;
            maxRe = 1;
            minIm = -1;
            minRe = -1;
        end
        
        % Titel
        state = Zustaende{states};
        title([prefix,' - Seitenbewegung: ',Steuergroessen{input},' auf ',state]);
        
        % Achsbeschriftung
        xlabel('{\bf \sigma} [rad/s]','Fontsize',12.0)
        ylabel('{\bf j\omega} [rad/s]','Fontsize',12.0)
        
        % Schriftgröße
        set(h1, 'FontSize',12.0);
        hold on;
        
        % Koordinatenachsen plotten
        plot([minRe maxRe],[0 0],'k','Linewidth',2);
        hold on;
        plot([0 0],[minIm maxIm],'k','Linewidth',2);
        grid on;
        axis equal
        set(h1, 'xlim',[minRe maxRe],'ylim',[minIm maxIm]);
    end
    
    %Ausgabe des Pol-Nulstellen-Diagramms in pdf-Datei 
    if (exist([Verzeichnis,'\Grafiken'],'dir') == 0)
        mkdir([Verzeichnis,'\Grafiken']);
    end    
    orient landscape
    if strcmp(state(1),'\')
        print(h,'-dpdf','-r300',[Verzeichnis,'\Grafiken\',prefix,' - Pol-Nullstellen - Steuergroessen auf ',state(2:length(state))]);
    else
        print(h,'-dpdf','-r300',[Verzeichnis,'\Grafiken\',prefix,' - Pol-Nullstellen - Steuergroessen auf ',state]);
    end
    
end

if AlleFlugzeuge~=2
    disp('Bitte mit beliebiger Taste fortsetzen...');
    pause;
end
close all
end